ARG ELIXIR_VERSION=1.14.0
ARG OTP_VERSION=25.0.4
ARG DEBIAN_VERSION=bullseye-20220801-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Allow ENV to be overridden at built time
ARG MIX_ENV

# set build ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/globo_ticket/mix.exs apps/globo_ticket/
COPY apps/globo_ticket_web/mix.exs apps/globo_ticket_web/
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

COPY config/config.exs config/
COPY config/globo_ticket/config.exs config/globo_ticket/${MIX_ENV}.exs config/globo_ticket/
COPY config/globo_ticket_web/config.exs config/globo_ticket_web/${MIX_ENV}.exs config/globo_ticket_web/
RUN mix deps.compile

# assets
COPY apps/globo_ticket_web/priv apps/globo_ticket_web/priv
COPY apps/globo_ticket_web/lib apps/globo_ticket_web/lib
COPY apps/globo_ticket_web/assets apps/globo_ticket_web/assets

RUN mix cmd --app globo_ticket_web mix assets.deploy

# Compile the release
COPY apps/globo_ticket/priv apps/globo_ticket/priv
COPY apps/globo_ticket/lib apps/globo_ticket/lib
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# Allow ENV to be overridden at built time
ARG MIX_ENV

# set runner ENV
ENV MIX_ENV="${MIX_ENV}"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/globo_ticket ./

USER nobody

CMD ["/app/bin/server"]

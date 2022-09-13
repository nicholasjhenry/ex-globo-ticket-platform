import Config

config :globo_ticket_web,
  ecto_repos: [GloboTicket.Repo],
  generators: [context_app: :globo_ticket]

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GloboTicketWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GloboTicket.PubSub,
  live_view: [signing_salt: "61A1cHtE"]

config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../../apps/globo_ticket_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

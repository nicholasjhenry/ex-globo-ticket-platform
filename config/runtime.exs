import Config

# CONFIG: globo_ticket

if config_env() in [:prod, :staging] do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :globo_ticket, GloboTicket.Repo,
    ssl: System.get_env("DATABASE_SSL") != "false",
    url: database_url,
    pool_size: String.to_integer(System.get_env("DATABASE_POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
end

# CONFIG: globo_ticket_web

# NOTE: `PORT` cannot be renames as it is a default for platforms such as Heroku
port = String.to_integer(System.get_env("PORT") || "4000")

unless config_env() in [:test] do
  endpoint =
    cond do
      url = System.get_env("ENDPOINT_URL") ->
        URI.parse(url)

      config_env() == :dev ->
        URI.parse("http://localhost:#{port}")

      true ->
        raise """
        environment variable ENDPOINT_URL is missing
        For example: https://example.com
        """
    end

  config :globo_ticket_web, GloboTicketWeb.Endpoint,
    url: endpoint |> Map.to_list() |> Keyword.take([:scheme, :host, :port])
end

if config_env() in [:prod, :staging] do
  secret_key_base =
    System.get_env("ENDPOINT_SECRET_KEY_BASE") ||
      raise """
      environment variable ENDPOINT_SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :globo_ticket_web, GloboTicketWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  if System.get_env("PHX_SERVER") do
    config :globo_ticket_web, GloboTicketWeb.Endpoint, server: true
  end
end

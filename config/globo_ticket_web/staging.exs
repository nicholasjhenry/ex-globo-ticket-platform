import Config

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :logger, level: :info

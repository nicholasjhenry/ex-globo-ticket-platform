import Config

config :globo_ticket, GloboTicket.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "globo_ticket_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "tJIPpEXI6e6oNCGrVtkkObakcrdUCbgcTYCS96F+Tg5DWXWrBmrQ8Rj9B+JqYnUI",
  server: false

config :logger, level: :warn

config :globo_ticket, GloboTicket.Mailer, adapter: Swoosh.Adapters.Test

config :phoenix, :plug_init_mode, :runtime

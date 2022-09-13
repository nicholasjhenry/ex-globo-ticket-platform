import Config

config :globo_ticket, GloboTicket.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "globo_ticket_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

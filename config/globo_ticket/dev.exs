import Config

config :globo_ticket, GloboTicket.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "globo_ticket_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

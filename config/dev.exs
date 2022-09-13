import Config

config :globo_ticket, GloboTicket.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "globo_ticket_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Vnu/iqXB/RsyjoHHQYCcQDtMUCIxqArxrsM6241fiyp9QV8fXY79mjtm1dVx3KLD",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/globo_ticket_web/(live|views)/.*(ex)$",
      ~r"lib/globo_ticket_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20

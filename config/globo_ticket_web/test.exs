import Config

config :globo_ticket_web, GloboTicketWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "tJIPpEXI6e6oNCGrVtkkObakcrdUCbgcTYCS96F+Tg5DWXWrBmrQ8Rj9B+JqYnUI",
  server: false

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime

import Config

config :globo_ticket,
  ecto_repos: [GloboTicket.Repo]

config :globo_ticket, GloboTicket.Repo, migration_timestamps: [type: :utc_datetime_usec]

config :bus_driver,
  handlers: [
    # Example
    # {"subscriptions", Handlers.Events}
  ]

config :globo_ticket, GloboTicket.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, false

import_config "#{config_env()}.exs"

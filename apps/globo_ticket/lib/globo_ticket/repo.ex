defmodule GloboTicket.Repo do
  use Ecto.Repo,
    otp_app: :globo_ticket,
    adapter: Ecto.Adapters.Postgres
end

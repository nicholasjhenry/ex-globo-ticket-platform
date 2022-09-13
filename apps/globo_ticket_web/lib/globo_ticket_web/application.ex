defmodule GloboTicketWeb.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GloboTicketWeb.Telemetry,
      GloboTicketWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: GloboTicketWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    GloboTicketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule GloboTicket.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GloboTicket.Repo,
      {Phoenix.PubSub, name: GloboTicket.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GloboTicket.Supervisor)
  end
end

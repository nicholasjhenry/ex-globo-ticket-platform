defmodule GloboTicket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GloboTicket.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GloboTicket.PubSub}
      # Start a worker by calling: GloboTicket.Worker.start_link(arg)
      # {GloboTicket.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GloboTicket.Supervisor)
  end
end

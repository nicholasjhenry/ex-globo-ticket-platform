defmodule GloboTicketWeb.ActLive.Shows.IndexComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Shows

  @impl true
  def update(assigns, socket) do
    shows = Shows.Handlers.Queries.list_shows(assigns.act.id)

    socket =
      socket
      |> assign(assigns)
      |> assign(:shows, shows)

    {:ok, socket}
  end
end

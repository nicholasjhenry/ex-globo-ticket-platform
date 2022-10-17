defmodule GloboTicketWeb.ActLive.Shows.IndexComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Shows

  @impl true
  def update(assigns, socket) do
    shows = list_shows(assigns.act.id)

    socket =
      socket
      |> assign(assigns)
      |> assign(:shows, shows)

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"venue-id" => venue_id, "start-at" => start_at}, socket) do
    act_id = socket.assigns.act.id
    {:ok, start_at, _} = DateTime.from_iso8601(start_at)

    {:ok, _} = Shows.Handlers.Commands.cancel_show(act_id, venue_id, start_at)

    {:noreply, assign(socket, :shows, list_shows(act_id))}
  end

  defp list_shows(act_id) do
    Shows.Handlers.Queries.list_shows(act_id)
  end
end

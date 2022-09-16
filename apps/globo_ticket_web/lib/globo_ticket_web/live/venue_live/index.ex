defmodule GloboTicketWeb.VenueLive.Index do
  use GloboTicketWeb, :live_view

  alias GloboTicket.Promotions.Venues

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :venues, list_venues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Venues")
    |> assign(:venue, nil)
  end

  defp list_venues do
    Venues.VenueQueries.list_venues()
  end
end

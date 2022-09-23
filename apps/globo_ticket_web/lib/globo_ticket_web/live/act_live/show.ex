defmodule GloboTicketWeb.ActLive.Show do
  use GloboTicketWeb, :live_view

  alias GloboTicket.Promotions.Acts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:act, Acts.Store.get_act!(id))}
  end

  defp page_title(:show), do: "Show Act"
  defp page_title(:edit), do: "Edit Act"
end

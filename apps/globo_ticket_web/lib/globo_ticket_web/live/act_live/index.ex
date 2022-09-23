defmodule GloboTicketWeb.ActLive.Index do
  use GloboTicketWeb, :live_view

  alias GloboTicket.Promotions.Acts

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :acts, list_acts())
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = apply_action(socket, socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, params) do
    id = params["id"] || Verity.Identifier.Uuid.generate()

    socket
    |> assign(:page_title, "Listing Acts")
    |> assign(:act, nil)
    |> assign(:id, id)
  end

  defp apply_action(socket, :new, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Act")
    |> assign(:act, %Acts.Act{id: id})
    |> assign(:id, :new)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Act")
    |> assign(:act, Acts.Store.get_act!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = Acts.Handlers.Commands.delete_act(id)

    {:noreply, assign(socket, :acts, list_acts())}
  end

  defp list_acts do
    Acts.Handlers.Queries.list_acts()
  end
end

defmodule GloboTicketWeb.ActLive.Shows.FormComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  import Phoenix.Component

  @impl true
  def update(%{act: act} = assigns, socket) do
    changeset =
      %Shows.Show{act_id: act.id}
      |> Shows.Show.changeset(%{})

    venues = Venues.Handlers.Queries.list_venues()

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
      |> assign(:venues, venues)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"show" => show_params}, socket) do
    changeset =
      %Shows.Show{act_id: socket.assigns.act.id}
      |> Shows.Show.changeset(show_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"show" => show_params}, socket) do
    save_show(socket, show_params)
  end

  defp save_show(socket, show_params) do
    show = %Shows.Show{act_id: socket.assigns.act.id}

    with {:ok, show} <- Shows.Show.parse(show, show_params),
         {:ok, _show} <-
           Shows.Handlers.Commands.schedule_show(show.act_id, show.venue_id, show.start_at) do
      {:noreply,
       socket
       |> put_flash(:info, "Show created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule GloboTicketWeb.VenueLive.FormComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Venues

  @impl true
  def update(%{venue: venue} = assigns, socket) do
    changeset = Venues.VenueInfo.changeset(venue, %{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"venue" => venue_params}, socket) do
    changeset =
      socket.assigns.venue
      |> Venues.VenueInfo.changeset(venue_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"venue" => venue_params}, socket) do
    save_venue(socket, socket.assigns.action, venue_params)
  end

  defp save_venue(socket, :new, venue_params) do
    with {:ok, venue} <-
           Venues.VenueInfo.from_params(socket.assigns.venue, venue_params),
         {:ok, _venue} <- Venues.VenueCommands.save_venue(venue) do
      {:noreply,
       socket
       |> put_flash(:info, "Venue created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_venue(socket, :edit, venue_params) do
    with {:ok, venue} <-
           Venues.VenueInfo.from_params(socket.assigns.venue, venue_params),
         {:ok, _venue} <- Venues.VenueCommands.save_venue(venue) do
      {:noreply,
       socket
       |> put_flash(:info, "Venue updated successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

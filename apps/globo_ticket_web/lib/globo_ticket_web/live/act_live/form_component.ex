defmodule GloboTicketWeb.ActLive.FormComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Acts
  alias GloboTicketWeb.Uploads

  import Phoenix.Component
  import GloboTicketWeb.Uploads, only: [error_to_string: 1]

  @impl true
  def update(%{act: act} = assigns, socket) do
    changeset = Acts.Act.changeset(act, %{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
      |> assign(:uploaded_files, [])
      |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"act" => act_params}, socket) do
    act_params = Uploads.put_upload_params(act_params, socket, :image)

    changeset =
      socket.assigns.act
      |> Acts.Act.changeset(act_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"act" => act_params}, socket) do
    save_act(socket, socket.assigns.action, act_params)
  end

  defp save_act(socket, :new, act_params) do
    uploaded_files = Uploads.handle_upload(socket, :image)

    act_params =
      Uploads.put_uploaded_params(act_params, :image, uploaded_files, socket.assigns.act.image)

    with {:ok, act} <-
           Acts.Act.parse(socket.assigns.act, act_params),
         {:ok, _act} <- Acts.Handlers.Commands.save_act(act) do
      {:noreply,
       socket
       |> update(:uploaded_files, &(&1 ++ uploaded_files))
       |> put_flash(:info, "Act created successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_act(socket, :edit, act_params) do
    uploaded_files = Uploads.handle_upload(socket, :image)

    act_params =
      Uploads.put_uploaded_params(act_params, :image, uploaded_files, socket.assigns.act.image)

    with {:ok, act} <-
           Acts.Act.parse(socket.assigns.act, act_params),
         {:ok, _act} <- Acts.Handlers.Commands.save_act(act) do
      {:noreply,
       socket
       |> update(:uploaded_files, &(&1 ++ uploaded_files))
       |> put_flash(:info, "Act updated successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

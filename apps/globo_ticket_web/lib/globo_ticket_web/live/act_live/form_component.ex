defmodule GloboTicketWeb.ActLive.FormComponent do
  use GloboTicketWeb, :live_component

  alias GloboTicket.Promotions.Acts

  import Phoenix.Component

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
    uploaded_files = handle_upload(socket)
    act_params = Map.put(act_params, "image", List.first(uploaded_files))

    with {:ok, act} <-
           Acts.Act.from_params(socket.assigns.act, act_params),
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
    with {:ok, act} <-
           Acts.Act.from_params(socket.assigns.act, act_params),
         {:ok, _act} <- Acts.Handlers.Commands.save_act(act) do
      {:noreply,
       socket
       |> put_flash(:info, "Act updated successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp handle_upload(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest =
        Path.join([:code.priv_dir(:globo_ticket_web), "static", "uploads", Path.basename(path)])

      File.cp!(path, dest)
      {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
    end)
  end
end

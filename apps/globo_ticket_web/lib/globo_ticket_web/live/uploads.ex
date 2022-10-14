defmodule GloboTicketWeb.Uploads do
  @moduledoc false

  alias GloboTicket.Promotions.Contents
  alias GloboTicketWeb.Router.Helpers, as: Routes

  @base Path.join([:code.priv_dir(:globo_ticket_web), "static", "uploads"])

  require Logger

  def mk_dir! do
    Logger.info("Creating #{@base}")
    File.mkdir_p!(@base)
  end

  def cp!(conn_or_socket, path, filename) do
    dest = Path.join([@base, filename])

    File.cp!(path, dest)

    Routes.static_path(conn_or_socket, "/uploads/#{Path.basename(dest)}")
  end

  def put_upload_params(params, socket, key) do
    upload = Map.fetch!(socket.assigns.uploads, key)

    case List.first(upload.entries) do
      %Phoenix.LiveView.UploadEntry{} = entry ->
        Map.put(params, to_string(key), entry.client_name)

      nil ->
        params
    end
  end

  def put_uploaded_params(params, key, uploaded_files, default) do
    upload = List.first(uploaded_files) || default
    Map.put(params, to_string(key), upload)
  end

  def handle_upload(socket, key) do
    Phoenix.LiveView.consume_uploaded_entries(socket, key, fn %{path: path}, entry ->
      attrs = %{
        id: entry.uuid,
        body: File.read!(path),
        name: entry.client_name,
        type: entry.client_type
      }

      {:ok, content} = Contents.Content.parse(%Contents.Content{}, attrs)
      {:ok, content} = Contents.Handlers.Commands.save_content(content)

      static_path = cp!(socket, path, content.name)
      {:ok, static_path}
    end)
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"
end

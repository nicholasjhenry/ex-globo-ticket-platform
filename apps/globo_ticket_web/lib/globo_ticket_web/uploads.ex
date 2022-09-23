defmodule GloboTicketWeb.Uploads do
  @moduledoc false

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

    static_path = Routes.static_path(conn_or_socket, "/uploads/#{Path.basename(dest)}")
    {:ok, static_path}
  end
end

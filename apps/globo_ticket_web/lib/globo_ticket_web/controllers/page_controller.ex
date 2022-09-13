defmodule GloboTicketWeb.PageController do
  use GloboTicketWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

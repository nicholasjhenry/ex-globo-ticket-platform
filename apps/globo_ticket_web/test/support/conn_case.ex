defmodule GloboTicketWeb.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import GloboTicketWeb.ConnCase
      import AssertHTML

      alias GloboTicketWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint GloboTicketWeb.Endpoint
    end
  end

  setup tags do
    GloboTicket.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def html_escape(unsafe) do
    {:safe, io_data} = Phoenix.HTML.html_escape(unsafe)
    to_string(io_data)
  end
end

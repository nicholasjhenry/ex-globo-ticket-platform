defmodule GloboTicketWeb.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import GloboTicketWeb.ConnCase

      alias GloboTicketWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint GloboTicketWeb.Endpoint
    end
  end

  setup tags do
    GloboTicket.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

defmodule GloboTicketWeb.VenueLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GloboTicket.Promotions.Venues

  defp create_venue(_context) do
    venue = Venues.Controls.VenueInfo.example()
    {:ok, _venue} = Venues.VenueCommands.save_venue(venue.uuid, venue)
    %{venue: venue}
  end

  describe "Index" do
    setup [:create_venue]

    test "lists all venues", %{conn: conn, venue: venue} do
      {:ok, _index_live, html} = live(conn, Routes.venue_index_path(conn, :index))

      assert html =~ "Listing Venues"
      assert html =~ venue.name
    end
  end
end

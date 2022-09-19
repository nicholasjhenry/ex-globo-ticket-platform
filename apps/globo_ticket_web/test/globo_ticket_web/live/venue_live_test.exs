defmodule GloboTicketWeb.VenueLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GloboTicket.Promotions.Venues

  defp create_venue(_context) do
    venue = Venues.Controls.VenueInfo.example()
    {:ok, _venue} = Venues.VenueCommands.save_venue(venue.id, venue)
    %{venue: venue}
  end

  describe "Index" do
    setup [:create_venue]

    test "lists all venues", %{conn: conn, venue: venue} do
      {:ok, _index_live, html} = live(conn, Routes.venue_index_path(conn, :index))

      assert html =~ "Listing Venues"
      assert html =~ venue.name
    end

    test "saves new venue", %{conn: conn} do
      id = Identifier.Uuid.Controls.Static.example()
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index, id: id))

      assert index_live |> element("a", "New Venue") |> render_click() =~
               "New Venue"

      assert_patch(index_live, Routes.venue_index_path(conn, :new, id))

      invalid_attrs = %{}

      assert index_live
             |> form("#venue-form", venue: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs = Venues.Controls.VenueInfo.Attrs.valid() |> Map.drop([:id])

      {:ok, _, html} =
        index_live
        |> form("#venue-form", venue: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      assert html =~ "Venue created successfully"
      assert html =~ create_attrs.name
    end
  end
end

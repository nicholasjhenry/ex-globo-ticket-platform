defmodule GloboTicketWeb.VenueLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GloboTicket.Promotions.Venues

  defp create_venue(_context) do
    venue_info = Venues.Controls.Venue.example()
    {:ok, _venue} = Venues.VenueCommands.save_venue(venue_info)
    %{venue: venue_info}
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

      create_attrs = Venues.Controls.Venue.Attrs.valid() |> Map.drop([:id])

      {:ok, _, html} =
        index_live
        |> form("#venue-form", venue: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      assert html =~ "Venue created successfully"
      assert html =~ create_attrs.name
    end

    test "updates venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index))

      assert index_live |> element("#venue-#{venue.id} a", "Edit") |> render_click() =~
               "Edit Venue"

      assert_patch(index_live, Routes.venue_index_path(conn, :edit, venue))

      invalid_attrs =
        Venues.Controls.Venue.Attrs.invalid(name: "Changed Name") |> Map.drop([:id])

      assert index_live
             |> form("#venue-form", venue: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs =
        Venues.Controls.Venue.Attrs.valid(name: "Changed Name") |> Map.drop([:id])

      {:ok, _, html} =
        index_live
        |> form("#venue-form", venue: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      assert html =~ "Venue updated successfully"
      assert html =~ "Changed Name"
    end

    test "deletes venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index))

      assert index_live |> element("#venue-#{venue.id} a", "Delete") |> render_click()
      # refute has_element?(index_live, "#user-#{user.id}")
    end
  end

  describe "Show" do
    setup [:create_venue]

    test "displays venue", %{conn: conn, venue: venue} do
      {:ok, _show_live, html} = live(conn, Routes.venue_show_path(conn, :show, venue))

      assert html =~ "Show Venue"
      assert html =~ venue.name
    end

    test "updates venue within modal", %{conn: conn, venue: venue} do
      {:ok, show_live, _html} = live(conn, Routes.venue_show_path(conn, :show, venue))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Venue"

      assert_patch(show_live, Routes.venue_show_path(conn, :edit, venue))

      invalid_attrs =
        Venues.Controls.Venue.Attrs.invalid(name: "Changed Name") |> Map.drop([:id])

      assert show_live
             |> form("#venue-form", venue: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs =
        Venues.Controls.Venue.Attrs.valid(name: "Changed Name") |> Map.drop([:id])

      {:ok, _, html} =
        show_live
        |> form("#venue-form", venue: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_show_path(conn, :show, venue))

      assert html =~ "Venue updated successfully"
      assert html =~ "Changed Name"
    end
  end
end

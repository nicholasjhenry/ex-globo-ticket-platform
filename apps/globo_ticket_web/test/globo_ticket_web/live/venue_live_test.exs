defmodule GloboTicketWeb.VenueLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GloboTicket.Promotions.Venues

  @form "[data-venue-form]"

  defp create_venue(_context) do
    venue_info = Venues.Controls.Venue.example()
    {:ok, _venue} = Venues.Handlers.Commands.save_venue(venue_info)
    %{venue: venue_info}
  end

  describe "Index" do
    setup [:create_venue]

    test "lists all venues", %{conn: conn, venue: venue} do
      {:ok, _index_live, html} = live(conn, Routes.venue_index_path(conn, :index))

      html
      |> assert_html("h1", "Listing Venues")
      |> assert_html("[data-venue-name]", venue.name)
    end

    test "saves new venue", %{conn: conn} do
      id = Identifier.Uuid.Controls.Static.example()
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index, id: id))

      html = index_live |> element("a", "New Venue") |> render_click()
      assert_html(html, "h2", "New Venue")

      assert_patch(index_live, Routes.venue_index_path(conn, :new, id))

      invalid_attrs = %{}

      html =
        index_live
        |> form(@form, venue: invalid_attrs)
        |> render_change()

      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      create_attrs = Venues.Controls.Venue.Attrs.valid()

      {:ok, _, html} =
        index_live
        |> form(@form, venue: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      html
      |> assert_html("[data-flash-info]", "Venue created successfully")
      |> assert_html("[data-venue-name]", create_attrs.name)
    end

    test "updates venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index))

      html = index_live |> element("[data-venue-id=#{venue.id}] a", "Edit") |> render_click()
      assert_html(html, "h2", "Edit Venue")

      assert_patch(index_live, Routes.venue_index_path(conn, :edit, venue))

      invalid_attrs = Venues.Controls.Venue.Attrs.invalid()
      html = index_live |> form(@form, venue: invalid_attrs) |> render_change()
      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      update_attrs = Venues.Controls.Venue.Attrs.valid(name: "Changed Name")

      {:ok, _, html} =
        index_live
        |> form(@form, venue: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      html
      |> assert_html("[data-flash-info]", "Venue updated successfully")
      |> assert_html("[data-venue-name]", "Changed Name")
    end

    test "deletes venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = live(conn, Routes.venue_index_path(conn, :index))

      assert index_live |> element("[data-venue-id=#{venue.id}] a", "Delete") |> render_click()
      refute has_element?(index_live, "[data-venue-id=#{venue.id}]")
    end
  end

  describe "Show" do
    setup [:create_venue]

    test "displays venue", %{conn: conn, venue: venue} do
      {:ok, _show_live, html} = live(conn, Routes.venue_show_path(conn, :show, venue))

      html
      |> assert_html("h1", "Show Venue")
      |> assert_html("[data-venue-name]", venue.name)
    end

    test "updates venue within modal", %{conn: conn, venue: venue} do
      {:ok, show_live, _html} = live(conn, Routes.venue_show_path(conn, :show, venue))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Venue"

      assert_patch(show_live, Routes.venue_show_path(conn, :edit, venue))

      invalid_attrs = Venues.Controls.Venue.Attrs.invalid()
      html = show_live |> form(@form, venue: invalid_attrs) |> render_change()
      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      update_attrs = Venues.Controls.Venue.Attrs.valid(name: "Changed Name")

      {:ok, _, html} =
        show_live
        |> form(@form, venue: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_show_path(conn, :show, venue))

      html
      |> assert_html("[data-flash-info]", "Venue updated successfully")
      |> assert_html("[data-venue-name]", "Changed Name")
    end
  end
end

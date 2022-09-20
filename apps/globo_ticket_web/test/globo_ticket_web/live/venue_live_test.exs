defmodule GloboTicketWeb.VenueLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest

  alias GloboTicket.Promotions.Venues

  @form_identifier "[data-venue-form]"

  defp create_venue(_context) do
    venue_info = Venues.Controls.Venue.example()
    {:ok, _venue} = Venues.Handlers.Commands.save_venue(venue_info)
    %{venue: venue_info}
  end

  describe "Index" do
    setup [:create_venue]

    test "lists all venues", %{conn: conn, venue: venue} do
      {:ok, _index_live, html} = list_venues(conn)

      html
      |> assert_html("h1", "Listing Venues")
      |> assert_html("[data-venue-id=#{venue.id}] [data-venue-name]", venue.name)
    end

    test "saves new venue", %{conn: conn} do
      venue_id = Identifier.Uuid.Controls.Random.example()
      {:ok, index_live, _html} = list_venues(conn, id: venue_id)

      index_live
      |> new_venue()
      |> assert_html("h2", "New Venue")

      assert_patch(index_live, Routes.venue_index_path(conn, :new, venue_id))

      html =
        index_live
        |> form(@form_identifier, venue: Venues.Controls.Venue.Attrs.invalid())
        |> render_change()

      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      create_attrs = Venues.Controls.Venue.Attrs.valid()

      {:ok, _, html} =
        index_live
        |> form(@form_identifier, venue: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      html
      |> assert_html("[data-flash-info]", "Venue created successfully")
      |> assert_html("[data-venue-id=#{venue_id}] [data-venue-name]", create_attrs.name)
    end

    test "updates venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = list_venues(conn)

      index_live
      |> edit_venue(venue)
      |> assert_html("h2", "Edit Venue")

      assert_patch(index_live, Routes.venue_index_path(conn, :edit, venue))

      html =
        index_live
        |> form(@form_identifier, venue: Venues.Controls.Venue.Attrs.invalid())
        |> render_change()

      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      update_attrs = Venues.Controls.Venue.Attrs.valid(name: "Changed Name")

      {:ok, _, html} =
        index_live
        |> form(@form_identifier, venue: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.venue_index_path(conn, :index))

      html
      |> assert_html("[data-flash-info]", "Venue updated successfully")
      |> assert_html("[data-venue-name]", update_attrs.name)
    end

    test "deletes venue in listing", %{conn: conn, venue: venue} do
      {:ok, index_live, _html} = list_venues(conn)

      index_live
      |> delete_venue(venue)
      |> refute_html("[data-venue-id=#{venue.id}] [data-venue-name]", venue.name)
    end

    defp list_venues(conn, params \\ %{}) do
      live(conn, Routes.venue_index_path(conn, :index, params))
    end

    defp new_venue(live) do
      live
      |> element("[data-action=venue-new]")
      |> render_click()
    end

    defp edit_venue(live, venue) do
      live
      |> element("[data-venue-id=#{venue.id}] [data-action=venue-edit]")
      |> render_click()
    end

    defp delete_venue(live, venue) do
      live
      |> element("[data-venue-id=#{venue.id}] [data-action=venue-delete]")
      |> render_click()
    end
  end

  describe "Show" do
    setup [:create_venue]

    test "displays venue", %{conn: conn, venue: venue} do
      {:ok, _show_live, html} = show_venue(conn, venue)

      html
      |> assert_html("h1", "Show Venue")
      |> assert_html("[data-venue-name]", venue.name)
    end

    test "updates venue within modal", %{conn: conn, venue: venue} do
      {:ok, show_live, _html} = show_venue(conn, venue)

      show_live
      |> edit_venue()
      |> assert_html("h2", "Edit Venue")

      assert_patch(show_live, Routes.venue_show_path(conn, :edit, venue))

      html =
        show_live
        |> form(@form_identifier, venue: Venues.Controls.Venue.Attrs.invalid())
        |> render_change()

      assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))

      update_attrs = Venues.Controls.Venue.Attrs.valid(name: "Changed Name")
      {:ok, _, html} = update_venue(conn, show_live, venue, update_attrs)

      html
      |> assert_html("[data-flash-info]", "Venue updated successfully")
      |> assert_html("[data-venue-name]", update_attrs.name)
    end

    defp edit_venue(live) do
      live
      |> element("[data-action=venue-edit]")
      |> render_click()
    end

    defp show_venue(conn, venue) do
      live(conn, Routes.venue_show_path(conn, :show, venue))
    end

    defp update_venue(conn, live, venue, attrs) do
      live
      |> form(@form_identifier, venue: attrs)
      |> render_submit()
      |> follow_redirect(conn, Routes.venue_show_path(conn, :show, venue))
    end
  end
end

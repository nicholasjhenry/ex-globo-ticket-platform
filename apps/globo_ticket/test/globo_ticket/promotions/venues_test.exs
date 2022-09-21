defmodule GloboTicket.Promotions.VenuesTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Venues.Controls
  alias GloboTicket.Promotions.Venues.Handlers
  alias GloboTicket.Promotions.Venues.Store

  test "venues are initially empty" do
    venues = Handlers.Queries.list_venues()
    assert Enum.empty?(venues)
  end

  test "when venue added then a venue is returned" do
    venue_info = Controls.Venue.example()

    result = Handlers.Commands.save_venue(venue_info)

    assert {:ok, _record} = result
    venues = Handlers.Queries.list_venues()
    assert Enum.any?(venues, &(&1.id == venue_info.id))
  end

  test "when venue added twice then one menu is added" do
    venue_info = Controls.Venue.example()
    _result = Handlers.Commands.save_venue(venue_info)

    result = Handlers.Commands.save_venue(venue_info)

    assert {:ok, _record} = result
    venues = Handlers.Queries.list_venues()
    assert Enum.count(venues) == 1
  end

  test "when set venue description then venue description is returned" do
    venue_info = Controls.Venue.example(name: "American Airlines Center")

    _result = Handlers.Commands.save_venue(venue_info)

    venue = Store.get_venue!(venue_info.id)
    assert venue.name == "American Airlines Center"
  end

  test "when set venue description to the same description then nothing is saved" do
    venue_info = Controls.Venue.example(name: "American Airlines Center")
    _result = Handlers.Commands.save_venue(venue_info)
    first_snapshot = Store.get_venue!(venue_info.id)

    _result = Handlers.Commands.save_venue(venue_info)

    second_snapshot = Store.get_venue!(venue_info.id)
    assert second_snapshot.last_updated_ticks == first_snapshot.last_updated_ticks
  end

  test "when venue is modified concurrently then exception is thrown" do
    venue_info = Controls.Venue.example(name: "American Airlines Center")

    _result = Handlers.Commands.save_venue(venue_info)
    venue = Store.get_venue!(venue_info.id)

    venue_info =
      Controls.Venue.example(
        name: "Change 1",
        last_updated_ticks: venue.last_updated_ticks
      )

    _result = Handlers.Commands.save_venue(venue_info)

    assert_raise Ecto.StaleEntryError, fn ->
      venue_info =
        Controls.Venue.example(
          name: "Change 2",
          last_updated_ticks: venue.last_updated_ticks
        )

      Handlers.Commands.save_venue(venue_info)
    end
  end

  test "when set venue location then venue location is returned" do
    venue_info =
      Controls.Venue.example(
        latitude: 45.508888,
        longitude: -73.561668
      )

    _result = Handlers.Commands.save_venue(venue_info)

    venue = Store.get_venue!(venue_info.id)
    assert venue.latitude == 45.508888
    assert venue.longitude == -73.561668
  end

  test "when set venue timezone then venue timezone is returned" do
    venue_info = Controls.Venue.example(time_zone: "America/Toronto")

    _result = Handlers.Commands.save_venue(venue_info)

    venue = Store.get_venue!(venue_info.id)
    assert venue.time_zone == "America/Toronto"
  end

  test "when venue deleted venue is not returned" do
    venue_info = Controls.Venue.example()
    _result = Handlers.Commands.save_venue(venue_info)

    _result = Handlers.Commands.delete_venue(venue_info.id)

    assert_raise Ecto.NoResultsError, fn -> Store.get_venue!(venue_info.id) end
  end
end

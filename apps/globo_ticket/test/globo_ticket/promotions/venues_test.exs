defmodule GloboTicket.Promotions.VenuesTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Venues.Controls
  alias GloboTicket.Promotions.Venues.Handlers
  alias GloboTicket.Promotions.Venues.Messages
  alias GloboTicket.Promotions.Venues.Store

  test "venues are initially empty" do
    venues = Handlers.Queries.list_venues()
    assert Enum.empty?(venues)
  end

  test "when venue added then a venue is returned" do
    venue = Controls.Venue.example()

    result = Handlers.Commands.save_venue(venue)

    assert {:ok, _record} = result
    venues = Handlers.Queries.list_venues()
    assert Enum.any?(venues, &(&1.id == venue.id))
  end

  test "when venue added twice then one venue is added" do
    venue = Controls.Venue.example()
    _result = Handlers.Commands.save_venue(venue)

    result = Handlers.Commands.save_venue(venue)

    assert {:ok, _record} = result
    venues = Handlers.Queries.list_venues()
    assert Enum.count(venues) == 1
  end

  test "when set venue description then venue description is returned" do
    venue = Controls.Venue.example(name: "American Airlines Center")

    _result = Handlers.Commands.save_venue(venue)

    venue = Store.get_venue!(venue.id)
    assert venue.name == "American Airlines Center"
  end

  test "when description is modified then an event is published" do
    venue = Controls.Venue.example(name: "American Airlines Center")

    _result = Handlers.Commands.save_venue(venue)

    assert_received {:promotions, %Messages.Events.VenueDescriptionChanged{}}
  end

  test "when set venue description to the same description then nothing is saved" do
    venue = Controls.Venue.example(name: "American Airlines Center")
    _result = Handlers.Commands.save_venue(venue)
    first_snapshot = Store.get_venue!(venue.id)

    _result = Handlers.Commands.save_venue(venue)

    second_snapshot = Store.get_venue!(venue.id)
    assert second_snapshot.last_updated_ticks == first_snapshot.last_updated_ticks
  end

  test "when venue is modified concurrently then exception is thrown" do
    venue = Controls.Venue.example(name: "American Airlines Center")

    _result = Handlers.Commands.save_venue(venue)
    venue = Store.get_venue!(venue.id)

    venue =
      Controls.Venue.example(
        name: "Change 1",
        last_updated_ticks: venue.last_updated_ticks
      )

    _result = Handlers.Commands.save_venue(venue)

    assert_raise Ecto.StaleEntryError, fn ->
      venue =
        Controls.Venue.example(
          name: "Change 2",
          last_updated_ticks: venue.last_updated_ticks
        )

      Handlers.Commands.save_venue(venue)
    end
  end

  test "when set venue location then venue location is returned" do
    venue =
      Controls.Venue.example(
        latitude: 45.508888,
        longitude: -73.561668
      )

    _result = Handlers.Commands.save_venue(venue)

    venue = Store.get_venue!(venue.id)
    assert venue.latitude == 45.508888
    assert venue.longitude == -73.561668
  end

  test "when set venue timezone then venue timezone is returned" do
    venue = Controls.Venue.example(time_zone: "America/Toronto")

    _result = Handlers.Commands.save_venue(venue)

    venue = Store.get_venue!(venue.id)
    assert venue.time_zone == "America/Toronto"
  end

  test "when venue deleted venue is not returned" do
    venue = Controls.Venue.example()
    _result = Handlers.Commands.save_venue(venue)

    _result = Handlers.Commands.delete_venue(venue.id)

    assert_raise Ecto.NoResultsError, fn -> Store.get_venue!(venue.id) end
  end
end

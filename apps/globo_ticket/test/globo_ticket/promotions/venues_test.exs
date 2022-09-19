defmodule GloboTicket.Promotions.VenuesTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Venues

  test "venues are initially empty" do
    venues = Venues.VenueQueries.list_venues()
    assert Enum.empty?(venues)
  end

  test "when venue added then a venue is returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    result = Venues.VenueCommands.save_venue(venue_info)

    assert {:ok, _record} = result
    venues = Venues.VenueQueries.list_venues()
    assert Enum.any?(venues, &(&1.id == venue_uuid))
  end

  test "when venue added twice then one menu is added" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    _result = Venues.VenueCommands.save_venue(venue_info)
    result = Venues.VenueCommands.save_venue(venue_info)

    assert {:ok, _record} = result
    venues = Venues.VenueQueries.list_venues()
    assert Enum.count(venues) == 1
  end

  test "when set venue description then venue description is returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    _result = Venues.VenueCommands.save_venue(venue_info)

    venue = Venues.VenueQueries.get_venue(venue_uuid)
    assert venue.name == "American Airlines Center"
  end

  test "when set venue description to the same description then nothing is saved" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    _result = Venues.VenueCommands.save_venue(venue_info)
    first_snapshot = Venues.VenueQueries.get_venue(venue_uuid)

    _result = Venues.VenueCommands.save_venue(venue_info)
    second_snapshot = Venues.VenueQueries.get_venue(venue_uuid)

    assert second_snapshot.last_updated_ticks == first_snapshot.last_updated_ticks
  end

  test "when venue is modified concurrently then exception is thrown" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    _result = Venues.VenueCommands.save_venue(venue_info)
    venue = Venues.VenueQueries.get_venue(venue_uuid)

    venue_info =
      Venues.Controls.VenueInfo.example(
        id: venue_uuid,
        name: "Change 1",
        last_updated_ticks: venue.last_updated_ticks
      )

    _result = Venues.VenueCommands.save_venue(venue_info)

    venue_info =
      Venues.Controls.VenueInfo.example(
        id: venue_uuid,
        name: "Change 2",
        last_updated_ticks: venue.last_updated_ticks
      )

    assert_raise Ecto.StaleEntryError, fn ->
      Venues.VenueCommands.save_venue(venue_info)
    end
  end

  test "when set venue location then venue location is returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(
        id: venue_uuid,
        latitude: 45.508888,
        longitude: -73.561668
      )

    _result = Venues.VenueCommands.save_venue(venue_info)

    venue = Venues.VenueQueries.get_venue(venue_uuid)
    assert venue.latitude == 45.508888
    assert venue.longitude == -73.561668
  end

  test "when set venue timezone then venue timezone is returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info = Venues.Controls.VenueInfo.example(id: venue_uuid, time_zone: "America/Toronto")
    _result = Venues.VenueCommands.save_venue(venue_info)

    venue = Venues.VenueQueries.get_venue(venue_uuid)
    assert venue.time_zone == "America/Toronto"
  end

  test "when venue deleted venue is not returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info =
      Venues.Controls.VenueInfo.example(id: venue_uuid, name: "American Airlines Center")

    _result = Venues.VenueCommands.save_venue(venue_info)

    _result = Venues.VenueCommands.delete_venue(venue_uuid)

    venue = Venues.VenueQueries.get_venue(venue_uuid)
    refute venue
  end
end

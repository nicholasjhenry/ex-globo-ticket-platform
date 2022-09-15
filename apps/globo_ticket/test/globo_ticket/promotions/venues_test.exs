defmodule GloboTicket.Promotions.VenuesTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Venues

  test "venues are initially empty" do
    venues = Venues.VenueQueries.list_venues()
    assert Enum.empty?(venues)
  end

  test "when venue added then a venue is returned" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info = Venues.Controls.VenueInfo.example(name: "American Airlines Center")
    result = Venues.VenueCommands.save_venue(venue_uuid, venue_info)

    assert {:ok, _record} = result
    venues = Venues.VenueQueries.list_venues()
    assert Enum.any?(venues, &(&1.uuid == venue_uuid))
  end

  test "when venue added twice then one menu is added" do
    venue_uuid = Identifier.Uuid.Controls.Static.example()

    venue_info = Venues.Controls.VenueInfo.example(name: "American Airlines Center")
    _result = Venues.VenueCommands.save_venue(venue_uuid, venue_info)
    result = Venues.VenueCommands.save_venue(venue_uuid, venue_info)

    assert {:ok, _record} = result
    venues = Venues.VenueQueries.list_venues()
    assert Enum.count(venues) == 1
  end
end

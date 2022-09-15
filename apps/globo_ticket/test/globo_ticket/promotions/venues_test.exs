defmodule GloboTicket.Promotions.VenuesTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Venues

  test "venues are initially empty" do
    venues = Venues.VenueQueries.list_venues()
    assert Enum.empty?(venues)
  end
end

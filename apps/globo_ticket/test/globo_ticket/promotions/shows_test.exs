defmodule GloboTicket.Promotions.ShowsTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows.Handlers
  alias GloboTicket.Promotions.Shows.Messages
  alias GloboTicket.Promotions.Venues

  alias Verity.Clock

  test "act initially has no shows" do
    act_id = given_act()
    shows = Handlers.Queries.list_shows(act_id)
    assert Enum.empty?(shows)
  end

  test "when show is scheduled then show is returned" do
    act_id = given_act()
    venue_id = given_venue()

    start_at = Clock.Controls.DateTime.example()
    {:ok, _record} = Handlers.Commands.schedule_show(act_id, venue_id, start_at)

    shows = Handlers.Queries.list_shows(act_id)

    assert Enum.any?(shows, &(Date.compare(&1.start_at, start_at) == :eq))
  end

  test "when show is scheduled then an event is published" do
    act_id = given_act()
    venue_id = given_venue()

    start_at = Clock.Controls.DateTime.example()
    {:ok, _record} = Handlers.Commands.schedule_show(act_id, venue_id, start_at)

    assert_received {:promotions, %Messages.Events.ShowAdded{}}
  end

  test "when show is scheduled twice then one show only is returned" do
    act_id = given_act()
    venue_id = given_venue()

    start_at = Clock.Controls.DateTime.example()

    {:ok, _record} = Handlers.Commands.schedule_show(act_id, venue_id, start_at)
    {:ok, _record} = Handlers.Commands.schedule_show(act_id, venue_id, start_at)

    shows = Handlers.Queries.list_shows(act_id)

    assert Enum.count(shows) == 1
  end

  test "when show is canceled the show is not returned" do
    act_id = given_act()
    venue_id = given_venue()

    start_at = Clock.Controls.DateTime.example()

    {:ok, _record} = Handlers.Commands.schedule_show(act_id, venue_id, start_at)
    {:ok, _record} = Handlers.Commands.cancel_show(act_id, venue_id, start_at)

    shows = Handlers.Queries.list_shows(act_id)

    assert Enum.empty?(shows)
  end

  def given_act do
    act = Acts.Controls.Act.generate()
    Acts.Handlers.Commands.save_act(act)
    act.id
  end

  def given_venue do
    venue = Venues.Controls.Venue.generate()
    Venues.Handlers.Commands.save_venue(venue)
    venue.id
  end
end

defmodule GloboTicketDemo do
  @moduledoc false

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  alias Verity.Clock

  def setup do
    setup_venues()
    setup_acts()
    setup_shows()
  end

  def setup_venues do
    Enum.each(1..100, fn _ ->
      Venues.Controls.Venue.generate() |> Venues.Handlers.Commands.save_venue()
    end)
  end

  def setup_acts do
    Enum.each(1..100, fn _ ->
      Acts.Controls.Act.generate() |> Acts.Handlers.Commands.save_act()
    end)
  end

  def setup_shows do
    venues = Venues.Handlers.Queries.list_venues()
    acts = Acts.Handlers.Queries.list_acts()

    Enum.each(1..100, fn _ ->
      venue = Enum.random(venues)
      act = Enum.random(acts)
      start_at = Clock.Controls.DateTime.generate()

      Shows.Handlers.Commands.schedule_show(act.id, venue.id, start_at)
    end)
  end
end

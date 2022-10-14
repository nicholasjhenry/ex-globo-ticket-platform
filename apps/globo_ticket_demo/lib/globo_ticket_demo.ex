defmodule GloboTicketDemo do
  @moduledoc false

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Venues

  def setup do
    setup_venues()
    setup_acts()
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
end

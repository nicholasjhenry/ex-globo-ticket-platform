defmodule GloboTicket.Promotions.Venues.Controls.VenueInfo do
  @moduledoc false

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues

  def example(attrs) do
    defaults = %{
      uuid: Identifier.Uuid.Controls.Random.example(),
      name: "American Airlines Center",
      city: "Montreal",
      latitude: 1.0,
      longitude: 2.0,
      last_updated_ticks: Ticks.zero()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Venues.VenueInfo, attrs)
  end
end

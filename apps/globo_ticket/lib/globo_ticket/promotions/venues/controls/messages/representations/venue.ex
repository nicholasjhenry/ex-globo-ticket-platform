defmodule GloboTicket.Promotions.Venues.Controls.Messages.Representations.Venue do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Controls
  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      venue_id: Identifier.Uuid.Controls.Random.example(),
      venue_description_representation:
        Controls.Messages.Representations.VenueDescription.generate(),
      venue_location_representation: Controls.Messages.Representations.VenueLocation.generate(),
      venue_time_zone_representation: Controls.Messages.Representations.VenueTimeZone.generate()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.Venue, attrs)
  end
end

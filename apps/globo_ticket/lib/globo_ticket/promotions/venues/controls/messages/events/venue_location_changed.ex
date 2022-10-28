defmodule GloboTicket.Promotions.Venues.Controls.Messages.Events.VenueLocationChanged do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Controls
  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      venue_id: Identifier.Uuid.Controls.Random.example(),
      venue_location_representation: Controls.Messages.Representations.VenueLocation.generate()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Events.VenueLocationChanged, attrs)
  end
end

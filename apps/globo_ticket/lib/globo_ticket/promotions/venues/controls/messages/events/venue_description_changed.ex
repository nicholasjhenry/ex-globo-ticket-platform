defmodule GloboTicket.Promotions.Venues.Controls.Messages.Events.VenueDescriptionChanged do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Controls
  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      venue_id: Identifier.Uuid.Controls.Random.example(),
      venue_description_representation:
        Controls.Messages.Representations.VenueDescription.generate()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Events.VenueDescriptionChanged, attrs)
  end
end

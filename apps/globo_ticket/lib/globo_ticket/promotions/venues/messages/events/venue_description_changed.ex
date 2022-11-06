defmodule GloboTicket.Promotions.Venues.Messages.Events.VenueDescriptionChanged do
  @moduledoc false

  @enforce_keys [:venue_id, :venue_description_representation]
  defstruct @enforce_keys
end

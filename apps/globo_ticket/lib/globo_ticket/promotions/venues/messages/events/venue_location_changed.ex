defmodule GloboTicket.Promotions.Venues.Messages.Events.VenueLocationChanged do
  @moduledoc false

  @enforce_keys [:venue_id, :venue_location_representation]
  defstruct @enforce_keys
end

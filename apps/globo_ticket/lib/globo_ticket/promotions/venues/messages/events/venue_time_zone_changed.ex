defmodule GloboTicket.Promotions.Venues.Messages.Events.VenueTimeZoneChanged do
  @moduledoc false

  @enforce_keys [:venue_id, :venue_time_zone_representation]
  defstruct @enforce_keys
end

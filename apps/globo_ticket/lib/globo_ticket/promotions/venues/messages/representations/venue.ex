defmodule GloboTicket.Promotions.Venues.Messages.Representations.Venue do
  @moduledoc false

  @enforce_keys [
    :venue_id,
    :venue_description_representation,
    :venue_location_representation,
    :venue_time_zone_representation
  ]

  defstruct @enforce_keys
end

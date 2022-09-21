defmodule GloboTicket.Promotions.Venues.Records.VenueRemoved do
  @moduledoc false

  use GloboTicket.Tombstone

  schema "promotion_venue_removals" do
    field :removed_at, :utc_datetime_usec
    field :venue_id, :id

    timestamps(updated_at: false)
  end
end

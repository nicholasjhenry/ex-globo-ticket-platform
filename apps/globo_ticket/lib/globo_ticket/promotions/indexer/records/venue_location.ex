defmodule GloboTicket.Promotions.Indexer.Records.VenueLocation do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_indexer_venue_locations" do
    field :venue_uuid, Ecto.UUID
    field :latitude, :float
    field :longitude, :float
    field :last_updated_at, :utc_datetime_usec

    timestamps()
  end
end

defmodule GloboTicket.Promotions.Indexer.Records.VenueDescription do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_indexer_venue_descriptions" do
    field :venue_uuid, Ecto.UUID
    field :name, :string
    field :city, :string
    field :last_updated_at, :utc_datetime_usec

    timestamps()
  end
end

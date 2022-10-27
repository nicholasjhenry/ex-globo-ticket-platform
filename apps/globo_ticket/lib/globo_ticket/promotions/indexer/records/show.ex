defmodule GloboTicket.Promotions.Indexer.Records.Show do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_show_index" do
    field :act_uuid, Ecto.UUID
    field :venue_uuid, Ecto.UUID
    field :act_title, :string
    field :act_image_hash, :string
    field :venue_name, :string
    field :venue_latitude, :float
    field :venue_longitude, :float

    field :start_at, :utc_datetime_usec

    timestamps()
  end
end

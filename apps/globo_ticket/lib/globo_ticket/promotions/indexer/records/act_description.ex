defmodule GloboTicket.Promotions.Indexer.Records.ActDescription do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_indexer_act_descriptions" do
    field :act_uuid, Ecto.UUID
    field :title, :string
    field :image_hash, :string
    field :last_updated_at, :utc_datetime_usec

    timestamps()
  end
end

defmodule GloboTicket.Promotions.Indexer.Records.Show do
  @moduledoc false

  use GloboTicket.Record

  alias GloboTicket.Ext

  schema "promotion_indexer_shows" do
    field :act_uuid, Ecto.UUID
    field :venue_uuid, Ecto.UUID
    field :start_at, :utc_datetime_usec
    field :hash, :string

    field :act_title, :string
    field :act_image_hash, :string
    field :venue_name, :string
    field :venue_latitude, :float
    field :venue_longitude, :float

    timestamps()
  end

  def hash(show) do
    hash =
      show
      |> Map.take([:act_uuid, :venue_uuid, :start_at])
      |> Ext.Map.to_hash()

    %{show | hash: hash}
  end
end

defmodule GloboTicket.Promotions.Shows.Records.Show do
  @moduledoc false

  use GloboTicket.Record

  alias GloboTicket.Ext
  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  schema "promotion_shows" do
    field :act_uuid, Ecto.UUID

    belongs_to :venue, Venues.Records.Venue,
      foreign_key: :venue_uuid,
      references: :uuid,
      type: Ecto.UUID

    field :start_at, :utc_datetime_usec
    field :hash, :string

    has_one :cancellation, Shows.Records.ShowCancelled

    timestamps(updated_at: false)
  end

  def hash(show) do
    hash =
      show
      |> Map.take([:act_uuid, :venue_uuid, :start_at])
      |> Ext.Map.to_hash()

    %{show | hash: hash}
  end
end

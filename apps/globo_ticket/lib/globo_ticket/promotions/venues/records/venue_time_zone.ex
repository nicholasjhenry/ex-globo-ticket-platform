defmodule GloboTicket.Promotions.Venues.Records.VenueTimeZone do
  @moduledoc false

  use GloboTicket.Record
  import Ecto.Changeset

  schema "promotion_venue_time_zones" do
    field :time_zone, :string
    field :venue_id, :id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(venue_time_zone, attrs) do
    venue_time_zone
    |> cast(attrs, [:time_zone])
    |> validate_required([:time_zone])
  end

  def equal?(nil, _next_snapshot) do
    false
  end

  def equal?(last_snapshot, next_snapshot) do
    last_snapshot.time_zone == next_snapshot.time_zone
  end

  def from_entity(entity, record) do
    %__MODULE__{
      venue_id: record.id,
      time_zone: entity.time_zone
    }
  end
end

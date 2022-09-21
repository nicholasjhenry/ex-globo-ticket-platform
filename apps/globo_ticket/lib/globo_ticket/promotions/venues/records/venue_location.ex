defmodule GloboTicket.Promotions.Venues.Records.VenueLocation do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_venue_locations" do
    field :latitude, :float
    field :longitude, :float
    field :venue_id, :id

    timestamps(updated_at: false)
  end

  def equal?(nil, _next_snapshot) do
    false
  end

  def equal?(last_snapshot, next_snapshot) do
    last_snapshot.longitude == next_snapshot.longitude &&
      last_snapshot.latitude == next_snapshot.latitude
  end

  def from_entity(entity, record) do
    %__MODULE__{
      venue_id: record.id,
      latitude: entity.latitude,
      longitude: entity.longitude
    }
  end
end

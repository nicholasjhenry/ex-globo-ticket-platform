defmodule GloboTicket.Promotions.Venues.VenueLocation do
  @moduledoc false

  use GloboTicket.Schema

  schema "promotion_venue_locations" do
    field :latitude, :float
    field :longitude, :float
    field :venue_id, :id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(venue_location, attrs) do
    venue_location
    |> cast(attrs, [:lat, :long])
    |> validate_required([:lat, :long])
  end

  def equal?(nil, _next_snapshot) do
    false
  end

  def equal?(last_snapshot, next_snapshot) do
    last_snapshot.longitude == next_snapshot.longitude &&
      last_snapshot.latitude == next_snapshot.latitude
  end
end

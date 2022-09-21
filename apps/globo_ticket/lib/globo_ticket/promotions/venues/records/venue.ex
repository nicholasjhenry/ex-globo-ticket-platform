defmodule GloboTicket.Promotions.Venues.Records.Venue do
  @moduledoc false

  use GloboTicket.Record

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  schema "promotion_venues" do
    field :uuid, Ecto.UUID
    has_one :description, Records.VenueDescription
    has_one :location, Records.VenueLocation
    has_one :time_zone, Records.VenueTimeZone
    has_one :removed, Records.VenueRemoved

    timestamps()
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
    |> unique_constraint(:uuid)
  end

  def to_entity(nil), do: nil

  def to_entity(record) do
    %Venues.Venue{
      id: record.uuid,
      name: record.description.name,
      city: record.description.city,
      last_updated_ticks: Ticks.from_date_time(record.description.inserted_at),
      latitude: record.location.latitude,
      longitude: record.location.longitude,
      location_last_updated_ticks: Ticks.from_date_time(record.location.inserted_at),
      time_zone: record.time_zone.time_zone,
      time_zone_last_updated_ticks: Ticks.from_date_time(record.time_zone.inserted_at)
    }
  end
end

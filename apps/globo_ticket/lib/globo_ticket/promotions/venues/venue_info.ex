defmodule GloboTicket.Promotions.Venues.VenueInfo do
  @moduledoc false

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues.Records

  use GloboTicket.Schema

  embedded_schema do
    field :name, :string
    field :city, :string
    field :last_updated_ticks, :integer
    field :latitude, :float
    field :longitude, :float
    field :location_last_updated_ticks, :integer
    field :time_zone, :string
    field :time_zone_last_updated_ticks, :integer
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:id, :name, :city, :latitude, :longitude, :time_zone])
    |> validate_required([:id, :name, :city, :latitude, :longitude, :time_zone])
  end

  def from_params(struct, params) do
    struct
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:converted)
  end

  def from_record(nil), do: nil

  def from_record(record) do
    %__MODULE__{
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

  def to_description_record(venue_info, venue) do
    %Records.VenueDescription{
      venue_id: venue.id,
      name: venue_info.name,
      city: venue_info.city
    }
  end

  def to_location_record(venue_info, venue) do
    %Records.VenueLocation{
      venue_id: venue.id,
      latitude: venue_info.latitude,
      longitude: venue_info.longitude
    }
  end

  def to_time_zone_record(venue_info, venue) do
    %Records.VenueTimeZone{
      venue_id: venue.id,
      time_zone: venue_info.time_zone
    }
  end
end

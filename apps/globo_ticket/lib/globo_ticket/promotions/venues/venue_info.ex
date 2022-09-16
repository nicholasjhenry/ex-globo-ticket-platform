defmodule GloboTicket.Promotions.Venues.VenueInfo do
  @moduledoc false

  use TypedStruct

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues

  typedstruct do
    field :uuid, Identifier.Uuid.t()
    field :name, String.t()
    field :city, String.t()
    field :last_updated_ticks, {integer(), non_neg_integer()}
    field :latitude, number()
    field :longitude, number()
    field :location_last_updated_ticks, {integer(), non_neg_integer()}
    field :time_zone, String.t()
    field :time_zone_last_updated_ticks, {integer(), non_neg_integer()}
  end

  def from_record(nil), do: nil

  def from_record(record) do
    %Venues.VenueInfo{
      uuid: record.uuid,
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
    %Venues.VenueDescription{
      venue_id: venue.id,
      name: venue_info.name,
      city: venue_info.city
    }
  end

  def to_location_record(venue_info, venue) do
    %Venues.VenueLocation{
      venue_id: venue.id,
      latitude: venue_info.latitude,
      longitude: venue_info.longitude
    }
  end

  def to_time_zone_record(venue_info, venue) do
    %Venues.VenueTimeZone{
      venue_id: venue.id,
      time_zone: venue_info.time_zone
    }
  end
end

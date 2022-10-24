defmodule GloboTicket.Promotions.Venues.Projection do
  @moduledoc false

  use GloboTicket.Projection

  alias GloboTicket.Promotions.Venues.Records

  def apply_all(entity, nil), do: entity

  def apply_all(entity, record) do
    entity
    |> apply(record)
    |> apply(record.description)
    |> apply(record.location)
    |> apply(record.time_zone)
  end

  def apply(entity, %Records.Venue{} = record) do
    %{entity | id: record.uuid}
  end

  def apply(entity, %Records.VenueDescription{} = record) do
    %{
      entity
      | name: record.name,
        city: record.city,
        last_updated_ticks: Ticks.from_date_time(record.inserted_at)
    }
  end

  def apply(entity, %Records.VenueLocation{} = record) do
    %{
      entity
      | latitude: record.latitude,
        longitude: record.longitude,
        location_last_updated_ticks: Ticks.from_date_time(record.inserted_at)
    }
  end

  def apply(entity, %Records.VenueTimeZone{} = record) do
    %{
      entity
      | time_zone: record.time_zone,
        time_zone_last_updated_ticks: Ticks.from_date_time(record.inserted_at)
    }
  end
end

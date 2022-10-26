defmodule GloboTicket.Promotions.Venues.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Messages
  alias GloboTicket.Promotions.Venues.Records

  def save_venue(venue) do
    with {:ok, record} <- save_entity(venue),
         {:ok, _} <- save_description(venue, record),
         {:ok, _} <- save_location(venue, record),
         {:ok, _} <- save_time_zone(venue, record) do
      {:ok, venue}
    end
  end

  def save_entity(venue) do
    record = %Records.Venue{uuid: venue.id}

    with {:ok, _} <- save_entity_record(Repo, record) do
      {:ok, get_record!(venue.id)}
    end
  end

  defp save_description(venue, entity_record) do
    with {:ok, description_record} <- save_snapshot(Repo, venue, entity_record, :description) do
      last_updated_ticks = Ticks.from_date_time(description_record.inserted_at)

      if Ticks.compare(last_updated_ticks, venue.last_updated_ticks) == :gt do
        message = build_venue_description_changed(venue, description_record)
        BusDriver.publish(:promotions, message)
      end

      {:ok, description_record}
    end
  end

  defp build_venue_description_changed(venue, description_record) do
    venue_description_representation = %Messages.Representations.VenueDescription{
      city: description_record.city,
      name: description_record.name,
      modified_date: description_record.inserted_at
    }

    %Messages.Events.VenueDescriptionChanged{
      venue_id: venue.id,
      venue_description_representation: venue_description_representation
    }
  end

  defp save_location(venue, record) do
    with {:ok, location_record} <-
           save_snapshot(Repo, venue, record, :location, :location_last_updated_ticks) do
      last_updated_ticks = Ticks.from_date_time(location_record.inserted_at)

      if Ticks.compare(last_updated_ticks, venue.location_last_updated_ticks) == :gt do
        message = build_venue_location_changed(venue, location_record)
        BusDriver.publish(:promotions, message)
      end

      {:ok, location_record}
    end
  end

  defp build_venue_location_changed(venue, location_record) do
    venue_location_representation = %Messages.Representations.VenueLocation{
      latitude: location_record.latitude,
      longitude: location_record.longitude
    }

    %Messages.Events.VenueLocationChanged{
      venue_id: venue.id,
      venue_location_representation: venue_location_representation
    }
  end

  defp save_time_zone(venue, record) do
    with {:ok, time_zone_record} <-
           save_snapshot(Repo, venue, record, :time_zone, :time_zone_last_updated_ticks) do
      last_updated_ticks = Ticks.from_date_time(time_zone_record.inserted_at)

      if Ticks.compare(last_updated_ticks, venue.time_zone_last_updated_ticks) == :gt do
        message = build_venue_time_zone_changed(venue, time_zone_record)
        BusDriver.publish(:promotions, message)
      end

      {:ok, time_zone_record}
    end
  end

  defp build_venue_time_zone_changed(venue, time_zone_record) do
    venue_time_zone_representation = %Messages.Representations.VenueTimeZone{
      time_zone: time_zone_record.time_zone
    }

    %Messages.Events.VenueTimeZoneChanged{
      venue_id: venue.id,
      venue_time_zone_representation: venue_time_zone_representation
    }
  end

  defp get_record!(venue_uuid) do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> get_record!(Repo, venue_uuid)
  end

  def delete_venue(venue_uuid) do
    Records.Venue
    |> get_record!(Repo, venue_uuid)
    |> soft_delete(Repo)
  end
end

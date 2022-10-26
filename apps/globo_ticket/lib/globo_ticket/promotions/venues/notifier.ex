defmodule GloboTicket.Promotions.Venues.Notifier do
  @moduledoc false

  alias Emu.Ticks

  alias GloboTicket.Promotions.Venues.Messages
  alias GloboTicket.Promotions.Venues.Records

  def notify(venue, %Records.VenueDescription{} = description_record) do
    last_updated_ticks = Ticks.from_date_time(description_record.inserted_at)

    if Ticks.compare(last_updated_ticks, venue.last_updated_ticks) == :gt do
      message = build_venue_description_changed(venue, description_record)
      BusDriver.publish(:promotions, message)
    end
  end

  def notify(venue, %Records.VenueLocation{} = location_record) do
    last_updated_ticks = Ticks.from_date_time(location_record.inserted_at)

    if Ticks.compare(last_updated_ticks, venue.location_last_updated_ticks) == :gt do
      message = build_venue_location_changed(venue, location_record)
      BusDriver.publish(:promotions, message)
    end
  end

  def notify(venue, %Records.VenueTimeZone{} = time_zone_record) do
    last_updated_ticks = Ticks.from_date_time(time_zone_record.inserted_at)

    if Ticks.compare(last_updated_ticks, venue.time_zone_last_updated_ticks) == :gt do
      message = build_venue_time_zone_changed(venue, time_zone_record)
      BusDriver.publish(:promotions, message)
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

  defp build_venue_time_zone_changed(venue, time_zone_record) do
    venue_time_zone_representation = %Messages.Representations.VenueTimeZone{
      time_zone: time_zone_record.time_zone
    }

    %Messages.Events.VenueTimeZoneChanged{
      venue_id: venue.id,
      venue_time_zone_representation: venue_time_zone_representation
    }
  end
end

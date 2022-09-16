defmodule GloboTicket.Promotions.Venues.VenueCommands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias Emu.Snapshot
  alias GloboTicket.Promotions.Venues

  def save_venue(uuid, venue_info) do
    venue = %Venues.Venue{uuid: uuid}

    with {:ok, venue} <- Emu.Repo.save_entity_record(venue) do
      venue = preload_venue(venue)
      description = Venues.VenueInfo.to_description_record(venue_info, venue)
      location = Venues.VenueInfo.to_location_record(venue_info, venue)
      time_zone = Venues.VenueInfo.to_time_zone_record(venue_info, venue)

      with {:ok, _} <- Emu.Repo.save_snapshot(venue_info, venue.description, description),
           {:ok, _} <-
             Emu.Repo.save_snapshot(
               venue_info,
               venue.location,
               location,
               :location_last_updated_ticks
             ),
           {:ok, _} <-
             Emu.Repo.save_snapshot(
               venue_info,
               venue.time_zone,
               time_zone,
               :time_zone_last_updated_ticks
             ) do
        {:ok, venue_info}
      end
    end
  end

  def delete_venue(venue_uuid) do
    venue = Repo.get_by(Venues.Venue, uuid: venue_uuid)
    Emu.Repo.soft_delete(venue)
  end

  defp preload_venue(venue_or_venues) do
    Repo.preload(venue_or_venues,
      description: Snapshot.last_snapshot(Venues.VenueDescription),
      location: Snapshot.last_snapshot(Venues.VenueLocation),
      time_zone: Snapshot.last_snapshot(Venues.VenueTimeZone)
    )
  end
end

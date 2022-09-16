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

      description = %Venues.VenueDescription{
        venue_id: venue.id,
        name: venue_info.name,
        city: venue_info.city
      }

      location = %Venues.VenueLocation{
        venue_id: venue.id,
        latitude: venue_info.latitude,
        longitude: venue_info.longitude
      }

      with {:ok, _} <- Emu.Repo.save_snapshot(venue_info, venue.description, description) do
        Emu.Repo.save_snapshot(venue_info, venue.location, location, :location_last_updated_ticks)
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
      location: Snapshot.last_snapshot(Venues.VenueLocation)
    )
  end
end

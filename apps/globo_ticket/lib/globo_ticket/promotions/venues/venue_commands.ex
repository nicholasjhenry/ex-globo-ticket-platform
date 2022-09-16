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
      venue = Repo.preload(venue, description: Snapshot.last_snapshot(Venues.VenueDescription))

      next_snapshot = %Venues.VenueDescription{
        venue_id: venue.id,
        name: venue_info.name,
        city: venue_info.city
      }

      Emu.Repo.save_snapshot(venue_info, venue.description, next_snapshot)
    end
  end

  def delete_venue(venue_uuid) do
    venue = Repo.get_by(Venues.Venue, uuid: venue_uuid)
    Emu.Repo.soft_delete(venue)
  end
end

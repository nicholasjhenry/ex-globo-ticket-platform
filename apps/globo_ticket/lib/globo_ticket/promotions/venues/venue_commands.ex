defmodule GloboTicket.Promotions.Venues.VenueCommands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias Emu.Snapshot
  alias GloboTicket.Promotions.Venues

  def save_venue(venue_info) do
    venue = %Venues.Venue{uuid: venue_info.id}

    with {:ok, venue} <- Emu.Repo.save_entity_record(venue) do
      venue =
        Venues.Venue
        |> preload_venue()
        |> Repo.get_by(uuid: venue.uuid)

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

  defp preload_venue(query) do
    query
    |> preload([venue], description: ^Snapshot.last_snapshot(Venues.VenueDescription, :venue_id))
    |> preload([venue], location: ^Snapshot.last_snapshot(Venues.VenueLocation, :venue_id))
    |> preload([venue], time_zone: ^Snapshot.last_snapshot(Venues.VenueTimeZone, :venue_id))
  end
end

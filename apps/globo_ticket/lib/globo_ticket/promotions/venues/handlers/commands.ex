defmodule GloboTicket.Promotions.Venues.Handlers.Commands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias Emu.Snapshot
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def save_venue(venue_info) do
    venue = %Records.Venue{uuid: venue_info.id}

    with {:ok, venue} <- Emu.Repo.save_entity_record(venue) do
      venue =
        Records.Venue
        |> preload_venue()
        |> Repo.get_by(uuid: venue.uuid)

      description = Venues.Venue.to_description_record(venue_info, venue)
      location = Venues.Venue.to_location_record(venue_info, venue)
      time_zone = Venues.Venue.to_time_zone_record(venue_info, venue)

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
    venue = Repo.get_by(Records.Venue, uuid: venue_uuid)
    Emu.Repo.soft_delete(venue)
  end

  defp preload_venue(query) do
    query
    |> preload([venue], description: ^Snapshot.last_snapshot(Records.VenueDescription, :venue_id))
    |> preload([venue], location: ^Snapshot.last_snapshot(Records.VenueLocation, :venue_id))
    |> preload([venue], time_zone: ^Snapshot.last_snapshot(Records.VenueTimeZone, :venue_id))
  end
end

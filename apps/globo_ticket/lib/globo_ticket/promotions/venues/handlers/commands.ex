defmodule GloboTicket.Promotions.Venues.Handlers.Commands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def save_venue(venue_info) do
    venue = %Records.Venue{uuid: venue_info.id}

    with {:ok, venue} <- Emu.Store.save_entity_record(venue) do
      venue =
        Records.Venue
        |> Venues.Query.snapshots_query()
        |> Repo.get_by(uuid: venue.uuid)

      with {:ok, _} <- Emu.Store.save_snapshot(venue_info, venue, :description),
           {:ok, _} <-
             Emu.Store.save_snapshot(venue_info, venue, :location, :location_last_updated_ticks),
           {:ok, _} <-
             Emu.Store.save_snapshot(
               venue_info,
               venue,
               :time_zone,
               :time_zone_last_updated_ticks
             ) do
        {:ok, venue_info}
      end
    end
  end

  def delete_venue(venue_uuid) do
    venue = Repo.get_by(Records.Venue, uuid: venue_uuid)
    Emu.Store.soft_delete(venue)
  end
end

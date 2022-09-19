defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias Emu.Snapshot
  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  use GloboTicket.QueryHandler

  def get_venue!(uuid) do
    Records.Venue
    |> preload_venue()
    |> Tombstone.present()
    |> Repo.get_by!(uuid: uuid)
    |> Venues.Venue.from_record()
  end

  def list_venues do
    Records.Venue
    |> preload_venue()
    |> Tombstone.present()
    |> Repo.all()
    |> Enum.map(&Venues.Venue.from_record/1)
  end

  defp preload_venue(query) do
    query
    |> preload([venue], description: ^Snapshot.last_snapshot(Records.VenueDescription, :venue_id))
    |> preload([venue], location: ^Snapshot.last_snapshot(Records.VenueLocation, :venue_id))
    |> preload([venue], time_zone: ^Snapshot.last_snapshot(Records.VenueTimeZone, :venue_id))
  end
end

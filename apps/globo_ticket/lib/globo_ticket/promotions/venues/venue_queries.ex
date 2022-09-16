defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias Emu.Snapshot
  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues

  use GloboTicket.QueryHandler

  def get_venue(uuid) do
    Venues.Venue
    |> Tombstone.present()
    |> Repo.get_by(uuid: uuid)
    |> preload_venue()
    |> Venues.VenueInfo.from_record()
  end

  def list_venues do
    Venues.Venue
    |> Tombstone.present()
    |> Repo.all()
    |> preload_venue()
    |> Enum.map(&Venues.VenueInfo.from_record/1)
  end

  defp preload_venue(venue_or_venues) do
    Repo.preload(venue_or_venues,
      description: Snapshot.last_snapshot(Venues.VenueDescription),
      location: Snapshot.last_snapshot(Venues.VenueLocation)
    )
  end
end

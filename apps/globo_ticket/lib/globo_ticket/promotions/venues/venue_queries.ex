defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias Emu.Snapshot
  alias Emu.Ticks
  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues

  use GloboTicket.QueryHandler

  def get_venue(uuid) do
    Venues.Venue
    |> Tombstone.present()
    |> Repo.get_by(uuid: uuid)
    |> preload_venue()
    |> to_venue_info()
  end

  def list_venues do
    Venues.Venue
    |> Tombstone.present()
    |> Repo.all()
    |> preload_venue()
    |> Enum.map(&to_venue_info/1)
  end

  defp preload_venue(venue_or_venues) do
    Repo.preload(venue_or_venues, descriptions: Snapshot.last_snapshot(Venues.VenueDescription))
  end

  defp to_venue_info(nil), do: nil

  defp to_venue_info(venue_record) do
    [description_record] = venue_record.descriptions

    %Venues.VenueInfo{
      uuid: venue_record.uuid,
      name: description_record.name,
      city: description_record.city,
      last_updated_ticks: Ticks.from_date_time(description_record.inserted_at)
    }
  end
end

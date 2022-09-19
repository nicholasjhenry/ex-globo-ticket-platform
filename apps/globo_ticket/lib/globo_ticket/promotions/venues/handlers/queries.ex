defmodule GloboTicket.Promotions.Venues.Handlers.Queries do
  @moduledoc """
  Handles queries for venues.
  """

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  use GloboTicket.QueryHandler

  def get_venue!(uuid) do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Tombstone.present()
    |> Repo.get_by!(uuid: uuid)
    |> Venues.Venue.from_record()
  end

  def list_venues do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Tombstone.present()
    |> Repo.all()
    |> Enum.map(&Venues.Venue.from_record/1)
  end
end

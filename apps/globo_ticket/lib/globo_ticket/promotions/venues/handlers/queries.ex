defmodule GloboTicket.Promotions.Venues.Handlers.Queries do
  @moduledoc """
  Handles queries for venues.
  """

  use GloboTicket.QueryHandler

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def list_venues do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Tombstone.present()
    |> Repo.all()
    |> Enum.map(&Venues.Venue.from_record/1)
  end
end

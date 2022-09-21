defmodule GloboTicket.Promotions.Venues.Handlers.Queries do
  @moduledoc false

  use GloboTicket.QueryHandler

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def list_venues do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Tombstone.present()
    |> Repo.all()
    |> Enum.map(&Records.Venue.to_entity/1)
  end
end

defmodule GloboTicket.Promotions.Venues.Handlers.Queries do
  @moduledoc false

  use GloboTicket.QueryHandler

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Projection
  alias GloboTicket.Promotions.Venues.Records

  def list_venues do
    records =
      Records.Venue
      |> Venues.Query.snapshots_query()
      |> Tombstone.present()
      |> Repo.all()

    Enum.map(records, &Projection.apply_all(%Venues.Venue{}, &1))
  end
end

defmodule GloboTicket.Promotions.Venues.Store do
  @moduledoc false

  use GloboTicket.Store

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Projection
  alias GloboTicket.Promotions.Venues.Records

  def get_venue!(uuid) do
    record =
      Records.Venue
      |> Venues.Query.snapshots_query()
      |> Tombstone.present()
      |> Repo.get_by!(uuid: uuid)

    Projection.apply_all(%Venues.Venue{}, record)
  end
end

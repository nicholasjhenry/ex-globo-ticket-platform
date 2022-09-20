defmodule GloboTicket.Promotions.Venues.Store do
  @moduledoc false

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  use GloboTicket.QueryHandler

  def get_venue!(uuid) do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Tombstone.present()
    |> Repo.get_by!(uuid: uuid)
    |> Records.Venue.to_entity()
  end
end
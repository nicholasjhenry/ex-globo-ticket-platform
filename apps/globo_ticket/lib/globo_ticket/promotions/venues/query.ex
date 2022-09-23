defmodule GloboTicket.Promotions.Venues.Query do
  @moduledoc false

  use GloboTicket.Query

  alias Emu.Snapshot
  alias GloboTicket.Promotions.Venues.Records

  def snapshots_query(query) do
    query
    |> preload([venue], description: ^Snapshot.last_snapshot(Records.VenueDescription, :venue_id))
    |> preload([venue], location: ^Snapshot.last_snapshot(Records.VenueLocation, :venue_id))
    |> preload([venue], time_zone: ^Snapshot.last_snapshot(Records.VenueTimeZone, :venue_id))
  end
end

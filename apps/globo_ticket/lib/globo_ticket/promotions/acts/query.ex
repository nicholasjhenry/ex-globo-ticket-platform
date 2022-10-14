defmodule GloboTicket.Promotions.Acts.Query do
  @moduledoc false

  use GloboTicket.Query

  alias Emu.Snapshot
  alias GloboTicket.Promotions.Acts.Records

  def snapshots_query(query) do
    query
    |> preload([act], description: ^Snapshot.last_snapshot(Records.ActDescription, :act_id))
  end
end

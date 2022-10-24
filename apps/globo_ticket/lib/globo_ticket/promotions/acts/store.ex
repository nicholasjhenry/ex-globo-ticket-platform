defmodule GloboTicket.Promotions.Acts.Store do
  @moduledoc false

  use GloboTicket.Store

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Projection
  alias GloboTicket.Promotions.Acts.Records

  def get_act!(uuid) do
    record =
      Records.Act
      |> Acts.Query.snapshots_query()
      |> Tombstone.present()
      |> Repo.get_by!(uuid: uuid)

    Projection.apply_all(%Acts.Act{}, record)
  end
end

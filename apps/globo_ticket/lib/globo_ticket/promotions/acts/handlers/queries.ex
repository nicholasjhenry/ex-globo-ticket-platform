defmodule GloboTicket.Promotions.Acts.Handlers.Queries do
  @moduledoc false

  use GloboTicket.QueryHandler

  alias Emu.Tombstone
  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Projection
  alias GloboTicket.Promotions.Acts.Records

  def list_acts do
    records =
      Records.Act
      |> Acts.Query.snapshots_query()
      |> Tombstone.present()
      |> Repo.all()

    Enum.map(records, &Projection.apply_all(%Acts.Act{}, &1))
  end
end

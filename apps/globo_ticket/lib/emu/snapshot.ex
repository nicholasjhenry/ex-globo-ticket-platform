defmodule Emu.Snapshot do
  @moduledoc """
  Supports the implementation of the Snapshot pattern.
  """

  import Ecto.Query

  def last_snapshot(struct, foreign_key, order_by \\ [desc: :inserted_at]) do
    # See: "Note: keep in mind operations like limit and offset in the preload query will affect the
    # whole result set and not each association. "
    #
    # -- https://hexdocs.pm/ecto/3.8.4/Ecto.Query.html#preload/3-preload-queries

    ranking_query =
      from r in struct,
        select: %{id: r.id, row_number: over(row_number(), :partition)},
        windows: [partition: [partition_by: ^foreign_key, order_by: ^order_by]]

    from r in struct,
      join: s in subquery(ranking_query),
      on: r.id == s.id and s.row_number <= 1
  end
end

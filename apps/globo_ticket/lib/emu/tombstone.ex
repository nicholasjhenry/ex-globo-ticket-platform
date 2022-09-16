defmodule Emu.Tombstone do
  @moduledoc """
  Supports the implementation of the Tombstone pattern.
  """
  import Ecto.Query

  def present(query) do
    from record in query, left_join: removed in assoc(record, :removed), where: is_nil(removed.id)
  end
end

defmodule Emu.Snapshot do
  @moduledoc """
  Supports the implementation of the Snapshot pattern.
  """
  import Ecto.Query

  def last_snapshot(query) do
    from query, order_by: [desc: :inserted_at], limit: 1
  end
end

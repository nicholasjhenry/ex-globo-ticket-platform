defmodule GloboTicket.Ext.Map do
  @moduledoc false

  alias GloboTicket.Ext

  def to_hash(map) do
    map
    |> Jason.encode!()
    |> Ext.String.to_hash()
  end
end

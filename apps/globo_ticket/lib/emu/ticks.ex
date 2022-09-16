defmodule Emu.Ticks do
  @moduledoc false

  def from_date_time(nil), do: {0, 0}

  def from_date_time(%DateTime{} = date_time) do
    DateTime.to_gregorian_seconds(date_time)
  end
end

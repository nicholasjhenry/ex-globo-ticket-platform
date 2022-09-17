defmodule Emu.Ticks do
  @moduledoc false

  def zero do
    {0, 0}
  end

  def any?(nil), do: false

  def any?(ticks) do
    ticks != {0, 0}
  end

  def equal?(rhs, lhs) do
    rhs == lhs
  end

  def from_date_time(nil), do: {0, 0}

  def from_date_time(%DateTime{} = date_time) do
    DateTime.to_gregorian_seconds(date_time)
  end
end

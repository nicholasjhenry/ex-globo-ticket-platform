defmodule Emu.Ticks do
  @moduledoc false

  def zero do
    {0, 0}
  end

  def any?(nil), do: false

  def any?(ticks) do
    ticks != {0, 0}
  end

  def compare(lhs, rhs) do
    cond do
      lhs == rhs ->
        :eq

      lhs > rhs ->
        :gt

      lhs < rhs ->
        :lt
    end
  end

  def from_date_time(nil), do: {0, 0}

  def from_date_time(%DateTime{} = date_time) do
    DateTime.to_gregorian_seconds(date_time)
  end

  def to_date_time(nil), do: nil

  def to_date_time(ticks) do
    DateTime.from_gregorian_seconds(elem(ticks, 0), {elem(ticks, 1), 0})
  end
end

defmodule Verity.Clock.Controls.DateTime do
  @moduledoc """
  A date-time provider.
  """

  @type t :: DateTime.t()

  @spec example() :: t
  def example do
    ~U[2000-01-01 00:00:00.000000Z]
  end

  def age({unit, :days}) do
    seconds = unit * 24 * 60 * 60
    example() |> DateTime.add(-seconds)
  end

  @spec string() :: String.t()
  def string do
    example() |> __MODULE__.to_string()
  end

  def to_string(date_time) do
    date_time |> Kernel.to_string() |> String.replace(" ", "T")
  end
end

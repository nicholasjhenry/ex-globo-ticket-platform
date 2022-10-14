defmodule Verity.Clock.Controls.DateTime do
  @moduledoc """
  A date-time provider.
  """

  @type t :: DateTime.t()

  @spec example() :: t
  def example do
    ~U[2000-01-01 00:00:00.000000Z]
  end
end

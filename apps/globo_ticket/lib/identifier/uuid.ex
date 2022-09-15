defmodule Identifier.Uuid do
  @moduledoc """
  A UUID-based identifier.
  """

  @type t :: String.t()

  @spec generate() :: t
  def generate do
    Ecto.UUID.generate()
  end
end

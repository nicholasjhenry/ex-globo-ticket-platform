defmodule Verity.Identifier.Uuid do
  @moduledoc """
  A UUID-based identifier.
  """

  @type t :: String.t()

  @spec generate() :: t
  def generate do
    UUID.uuid4()
  end
end

defmodule GloboTicket.Control do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Verity.Identifier
      alias Verity.Clock
    end
  end
end

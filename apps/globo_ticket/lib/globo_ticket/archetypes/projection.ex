defmodule GloboTicket.Projection do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Emu.Ticks

      import Kernel, except: [apply: 2]
    end
  end
end

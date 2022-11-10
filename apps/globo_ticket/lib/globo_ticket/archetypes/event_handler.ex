defmodule GloboTicket.EventHandler do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, warn: false
      import Emu.Store

      alias Emu.Ticks
      alias GloboTicket.Repo
    end
  end
end

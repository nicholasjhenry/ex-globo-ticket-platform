defmodule GloboTicket.CommandHandler do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, warn: false
      import Emu.Store

      alias GloboTicket.Repo
    end
  end
end

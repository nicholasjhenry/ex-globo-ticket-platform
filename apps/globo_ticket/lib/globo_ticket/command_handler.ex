defmodule GloboTicket.CommandHandler do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias GloboTicket.Repo
    end
  end
end

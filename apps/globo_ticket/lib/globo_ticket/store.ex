defmodule GloboTicket.Store do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query, warn: false
      alias GloboTicket.Repo
    end
  end
end

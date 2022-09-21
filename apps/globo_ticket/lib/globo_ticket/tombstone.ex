defmodule GloboTicket.Tombstone do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import GloboTicket.Tombstone

      @timestamps_opts [type: :utc_datetime_usec]

      @type t :: %__MODULE__{}
    end
  end
end

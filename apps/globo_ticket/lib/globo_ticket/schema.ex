defmodule GloboTicket.Schema do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query
      import GloboTicket.Schema

      alias Ecto.Changeset
      alias Ecto.Query

      @timestamps_opts [type: :utc_datetime_usec]

      @type t :: %__MODULE__{}
      @type changeset :: Ecto.Changeset.t(__MODULE__.t())
    end
  end
end

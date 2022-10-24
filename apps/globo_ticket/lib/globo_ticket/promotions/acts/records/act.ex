defmodule GloboTicket.Promotions.Acts.Records.Act do
  @moduledoc false

  use GloboTicket.Record

  alias GloboTicket.Promotions.Acts.Records

  schema "promotion_acts" do
    field :uuid, Ecto.UUID
    has_one :description, Records.ActDescription
    has_one :removed, Records.ActRemoved

    timestamps()
  end
end

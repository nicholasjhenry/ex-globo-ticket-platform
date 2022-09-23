defmodule GloboTicket.Promotions.Acts.Records.ActRemoved do
  @moduledoc false

  use GloboTicket.Tombstone

  schema "promotion_act_removals" do
    field :removed_at, :utc_datetime_usec
    field :act_id, :id

    timestamps(updated_at: false)
  end
end

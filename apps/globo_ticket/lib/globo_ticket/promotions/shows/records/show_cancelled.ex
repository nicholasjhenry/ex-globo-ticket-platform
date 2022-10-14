defmodule GloboTicket.Promotions.Shows.Records.ShowCancelled do
  @moduledoc false

  use GloboTicket.Tombstone

  schema "promotion_show_cancellations" do
    field :cancelled_at, :utc_datetime_usec
    field :show_id, :id

    timestamps(updated_at: false)
  end
end

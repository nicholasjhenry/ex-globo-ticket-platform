defmodule GloboTicket.Promotions.Shows.Records.Show do
  @moduledoc false

  use GloboTicket.Record

  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  schema "promotion_shows" do
    field :act_uuid, Ecto.UUID

    belongs_to :venue, Venues.Records.Venue,
      foreign_key: :venue_uuid,
      references: :uuid,
      type: Ecto.UUID

    has_one :cancellation, Shows.Records.ShowCancelled

    field :start_at, :utc_datetime_usec

    timestamps(updated_at: false)
  end
end

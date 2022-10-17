defmodule GloboTicket.Promotions.Shows.Show do
  @moduledoc false

  use GloboTicket.Entity

  @primary_key false

  alias GloboTicket.Promotions.Venues

  embedded_schema do
    field :act_id
    field :venue_id
    embeds_one :venue, Venues.Venue
    field :start_at, :utc_datetime_usec
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:act_id, :venue_id, :start_at])
    |> validate_required([:act_id, :venue_id, :start_at])
  end

  def parse(struct, params) do
    struct
    |> changeset(params)
    |> apply_action(:parsed)
  end
end

defmodule GloboTicket.Promotions.Venues.Records.VenueRemoved do
  @moduledoc false
  use GloboTicket.Schema

  schema "promotion_venue_removals" do
    field :removed_at, :utc_datetime_usec
    field :venue_id, :id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(venue_removed, attrs) do
    venue_removed
    |> cast(attrs, [:removed_at])
    |> validate_required([:removed_at])
  end
end

defmodule GloboTicket.Promotions.Venues.Venue do
  @moduledoc false

  use GloboTicket.Schema

  schema "promotion_venues" do
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
    |> unique_constraint(:uuid)
  end
end

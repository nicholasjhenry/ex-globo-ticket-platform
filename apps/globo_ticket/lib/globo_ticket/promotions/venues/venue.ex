defmodule GloboTicket.Promotions.Venues.Venue do
  @moduledoc false

  use GloboTicket.Schema

  alias GloboTicket.Promotions.Venues

  schema "promotion_venues" do
    field :uuid, Ecto.UUID
    has_one :description, Venues.VenueDescription
    has_one :location, Venues.VenueLocation
    has_one :removed, Venues.VenueRemoved

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

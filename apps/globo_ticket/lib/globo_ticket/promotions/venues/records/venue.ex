defmodule GloboTicket.Promotions.Venues.Records.Venue do
  @moduledoc false

  use GloboTicket.Schema

  alias GloboTicket.Promotions.Venues.Records

  schema "promotion_venues" do
    field :uuid, Ecto.UUID
    has_one :description, Records.VenueDescription
    has_one :location, Records.VenueLocation
    has_one :time_zone, Records.VenueTimeZone
    has_one :removed, Records.VenueRemoved

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

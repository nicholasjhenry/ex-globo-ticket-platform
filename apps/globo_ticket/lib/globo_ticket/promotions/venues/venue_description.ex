defmodule GloboTicket.Promotions.Venues.VenueDescription do
  @moduledoc false

  use GloboTicket.Schema

  schema "promotion_venue_descriptions" do
    field :city, :string
    field :name, :string
    field :venue_id, :id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(venue_description, attrs) do
    venue_description
    |> cast(attrs, [:name, :city])
    |> validate_required([:name, :city])
  end
end

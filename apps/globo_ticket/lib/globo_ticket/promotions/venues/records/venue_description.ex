defmodule GloboTicket.Promotions.Venues.Records.VenueDescription do
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

  def equal?(nil, _next_snapshot) do
    false
  end

  def equal?(last_snapshot, next_snapshot) do
    last_snapshot.name == next_snapshot.name &&
      last_snapshot.city == next_snapshot.city
  end

  def from_entity(entity, record) do
    %__MODULE__{
      venue_id: record.id,
      name: entity.name,
      city: entity.city
    }
  end
end

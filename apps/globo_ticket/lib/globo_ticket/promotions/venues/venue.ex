defmodule GloboTicket.Promotions.Venues.Venue do
  @moduledoc false

  use GloboTicket.Entity

  embedded_schema do
    field :name, :string
    field :city, :string
    field :last_updated_ticks, :integer
    field :latitude, :float
    field :longitude, :float
    field :location_last_updated_ticks, :integer
    field :time_zone, :string
    field :time_zone_last_updated_ticks, :integer
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:id, :name, :city, :latitude, :longitude, :time_zone])
    |> validate_required([:id, :name, :city, :latitude, :longitude, :time_zone])
  end

  def from_params(struct, params) do
    struct
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:converted)
  end
end

defmodule GloboTicket.Promotions.Venues.VenueInfo do
  @moduledoc false

  use TypedStruct

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues

  typedstruct do
    field :uuid, Identifier.Uuid.t()
    field :name, String.t()
    field :city, String.t()
    field :latitude, number()
    field :longitude, number()
    field :last_updated_ticks, {integer(), non_neg_integer()}
    field :location_last_updated_ticks, {integer(), non_neg_integer()}
  end

  def from_record(nil), do: nil

  def from_record(record) do
    %Venues.VenueInfo{
      uuid: record.uuid,
      name: record.description.name,
      city: record.description.city,
      last_updated_ticks: Ticks.from_date_time(record.description.inserted_at),
      latitude: record.location.latitude,
      longitude: record.location.longitude,
      location_last_updated_ticks: Ticks.from_date_time(record.location.inserted_at)
    }
  end
end

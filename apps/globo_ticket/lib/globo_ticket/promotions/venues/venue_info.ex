defmodule GloboTicket.Promotions.Venues.VenueInfo do
  @moduledoc false

  use TypedStruct

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues

  typedstruct do
    field :uuid, Identifier.Uuid.t()
    field :name, String.t()
    field :city, String.t()
    field :last_updated_ticks, {integer(), non_neg_integer()}
  end

  def from_record(nil), do: nil

  def from_record(venue_record) do
    description_record = venue_record.description

    %Venues.VenueInfo{
      uuid: venue_record.uuid,
      name: description_record.name,
      city: description_record.city,
      last_updated_ticks: Ticks.from_date_time(description_record.inserted_at)
    }
  end
end

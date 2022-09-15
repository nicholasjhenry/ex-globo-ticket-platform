defmodule GloboTicket.Promotions.Venues.VenueInfo do
  @moduledoc false

  use TypedStruct

  typedstruct do
    field :uuid, Identifier.Uuid.t()
    field :name, String.t()
  end
end

defmodule GloboTicket.Promotions.Venues.Messages.Representations.VenueDescription do
  @moduledoc false

  @enforce_keys [:city, :name, :modified_date]
  defstruct @enforce_keys
end

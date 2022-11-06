defmodule GloboTicket.Promotions.Venues.Messages.Representations.VenueLocation do
  @moduledoc false

  @enforce_keys [:latitude, :longitude, :modified_date]
  defstruct @enforce_keys
end

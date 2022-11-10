defmodule GloboTicket.Promotions.Shows.Messages.Events.ShowAdded do
  @moduledoc false

  @enforce_keys [:act_representation, :venue_representation, :show_representation]
  defstruct @enforce_keys
end

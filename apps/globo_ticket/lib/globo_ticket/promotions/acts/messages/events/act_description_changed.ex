defmodule GloboTicket.Promotions.Acts.Messages.Events.ActDescriptionChanged do
  @moduledoc false

  @enforce_keys [:act_id, :act_description_representation]
  defstruct @enforce_keys
end

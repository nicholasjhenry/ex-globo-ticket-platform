defmodule GloboTicket.Promotions.Acts.Messages.Representations.ActDescription do
  @moduledoc false

  @enforce_keys [:title, :image_hash, :modified_date]
  defstruct @enforce_keys
end

defmodule GloboTicket.Ext.String do
  @moduledoc false

  def to_hash(string) do
    :sha512
    |> :crypto.hash(string)
    |> Base.encode16()
    |> String.downcase()
  end
end

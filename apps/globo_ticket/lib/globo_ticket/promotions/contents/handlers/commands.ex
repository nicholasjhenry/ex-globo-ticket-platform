defmodule GloboTicket.Promotions.Contents.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Ext

  def save_content(content) do
    hash = Ext.String.to_hash(content.body)
    new_name = to_name(content, hash)
    hashed_content = %{content | hash: hash, name: new_name}

    {:ok, hashed_content}
  end

  defp to_name(content, hash) do
    ext = Path.extname(content.name)
    basename = Path.basename(content.name, ext)
    Enum.join([basename, "-", hash, ext])
  end
end

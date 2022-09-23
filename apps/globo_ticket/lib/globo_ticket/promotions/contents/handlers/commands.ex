defmodule GloboTicket.Promotions.Contents.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  def save_content(content) do
    hash = to_hash(content)
    new_name = to_name(content, hash)
    hashed_content = %{content | hash: hash, name: new_name}

    {:ok, hashed_content}
  end

  defp to_hash(content) do
    :sha512
    |> :crypto.hash(content.body)
    |> Base.encode16()
    |> String.downcase()
  end

  defp to_name(content, hash) do
    ext = Path.extname(content.name)
    basename = Path.basename(content.name, ext)
    Enum.join([basename, "-", hash, ext])
  end
end

defmodule GloboTicket.Promotions.Contents.Controls.Content do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Contents

  def example(attrs \\ %{}) do
    defaults = %{
      id: Identifier.Uuid.Controls.Static.example(),
      name: "image.png",
      type: "image/png",
      body: File.read!(pathname())
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Contents.Content, attrs)
  end

  def hash do
    "78d95bc081688f1ef9e0721329a6538fd0f6f5079767709775bf58b5358e90f80e3ddf6745bccce378728f14d965c7cd513236f35537b67cee10f2211ac53ceb"
  end

  defp pathname do
    Path.join([:code.priv_dir(:globo_ticket), "controls", "image.png"])
  end
end

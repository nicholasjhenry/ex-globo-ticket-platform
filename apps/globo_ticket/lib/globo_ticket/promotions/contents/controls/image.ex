defmodule GloboTicket.Promotions.Contents.Controls.Image do
  @moduledoc false

  use GloboTicket.Control

  def example do
    %{
      last_modified: 1_594_171_879_000,
      name: "image.png",
      content: File.read!(pathname()),
      type: "image/png"
    }
  end

  defp pathname do
    Path.join([:code.priv_dir(:globo_ticket), "controls", "image.png"])
  end
end

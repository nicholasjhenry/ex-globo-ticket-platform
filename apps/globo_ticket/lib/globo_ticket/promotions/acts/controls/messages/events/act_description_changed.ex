defmodule GloboTicket.Promotions.Acts.Controls.Messages.Events.ActDescriptionChanged do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Acts.Controls
  alias GloboTicket.Promotions.Acts.Messages

  def generate(attrs \\ []) do
    defaults = %{
      act_id: Identifier.Uuid.Controls.Random.example(),
      act_description_representation: Controls.Messages.Representations.ActDescription.generate()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Events.ActDescriptionChanged, attrs)
  end
end

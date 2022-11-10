defmodule GloboTicket.Promotions.Shows.Controls.Messages.Representations.Show do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Shows.Messages

  def generate(attrs \\ []) do
    defaults = %{
      start_at: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.Show, attrs)
  end
end

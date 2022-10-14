defmodule GloboTicket.Promotions.Shows.Controls.Show do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Shows

  def example(attrs \\ %{}) do
    defaults = %{
      start_at: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Shows.Show, attrs)
  end
end

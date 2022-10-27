defmodule GloboTicket.Promotions.Shows.Controls.Messages.Events.ShowAdded do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Venues

  alias GloboTicket.Promotions.Shows.Controls
  alias GloboTicket.Promotions.Shows.Messages

  def generate(attrs \\ []) do
    defaults = %{
      act_representation: Acts.Controls.Messages.Representations.Act.generate(),
      venue_representation: Venues.Controls.Messages.Representations.Venue.generate(),
      show_representation: Controls.Messages.Representations.Show.generate()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Events.ShowAdded, attrs)
  end
end

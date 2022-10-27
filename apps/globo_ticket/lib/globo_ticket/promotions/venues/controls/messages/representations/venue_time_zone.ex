defmodule GloboTicket.Promotions.Venues.Controls.Messages.Representations.VenueTimeZone do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      time_zone: "America/Toronto",
      modified_date: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.VenueTimeZone, attrs)
  end
end

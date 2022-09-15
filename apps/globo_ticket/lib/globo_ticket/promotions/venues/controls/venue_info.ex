defmodule GloboTicket.Promotions.Venues.Controls.VenueInfo do
  @moduledoc false

  alias GloboTicket.Promotions.Venues

  def example(attrs) do
    defaults = %{
      uuid: Identifier.Uuid.Controls.Random.example(),
      name: "American Airlines Center",
      city: "Montreal"
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Venues.VenueInfo, attrs)
  end
end

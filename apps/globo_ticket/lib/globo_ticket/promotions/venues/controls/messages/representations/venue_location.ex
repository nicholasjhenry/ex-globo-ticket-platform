defmodule GloboTicket.Promotions.Venues.Controls.Messages.Representations.VenueLocation do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      latitude: Faker.Address.latitude(),
      longitude: Faker.Address.longitude(),
      modified_date: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.VenueLocation, attrs)
  end
end

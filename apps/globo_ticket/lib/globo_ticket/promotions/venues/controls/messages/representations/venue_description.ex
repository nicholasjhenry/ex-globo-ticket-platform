defmodule GloboTicket.Promotions.Venues.Controls.Messages.Representations.VenueDescription do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Venues.Messages

  def generate(attrs \\ []) do
    defaults = %{
      city: Faker.Address.city(),
      name: Faker.Company.name() <> " Center",
      modified_date: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.VenueDescription, attrs)
  end
end

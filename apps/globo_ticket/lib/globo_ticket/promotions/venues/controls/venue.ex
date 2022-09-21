defmodule GloboTicket.Promotions.Venues.Controls.Venue do
  @moduledoc false

  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues
  alias Verity.Identifier

  def example(attrs \\ %{}) do
    defaults = %{
      id: Identifier.Uuid.Controls.Static.example(),
      name: "American Airlines Center",
      city: "Montreal",
      last_updated_ticks: Ticks.zero(),
      latitude: 1.0,
      longitude: 2.0,
      location_last_updated_ticks: Ticks.zero(),
      time_zone: "America/Toronto",
      time_zone_last_updated_ticks: Ticks.zero()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Venues.Venue, attrs)
  end

  def generate(attrs \\ %{}) do
    defaults = %{
      id: Identifier.Uuid.Controls.Random.example(),
      name: Faker.Company.name() <> " Center",
      city: Faker.Address.city(),
      last_updated_ticks: Ticks.zero(),
      latitude: Faker.Address.latitude(),
      longitude: Faker.Address.longitude(),
      location_last_updated_ticks: Ticks.zero(),
      time_zone: "America/Toronto",
      time_zone_last_updated_ticks: Ticks.zero()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Venues.Venue, attrs)
  end

  defmodule Attrs do
    @moduledoc false

    def valid(attrs \\ %{}) do
      defaults = %{
        name: "American Airlines Center",
        city: "Montreal",
        latitude: 1.0,
        longitude: 2.0,
        time_zone: "America/Toronto"
      }

      Enum.into(attrs, defaults)
    end

    def invalid(attrs \\ %{}) do
      defaults = %{
        name: nil,
        city: nil,
        latitude: nil,
        longitude: nil,
        time_zone: nil
      }

      Enum.into(attrs, defaults)
    end
  end
end

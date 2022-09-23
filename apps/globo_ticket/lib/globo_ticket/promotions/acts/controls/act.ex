defmodule GloboTicket.Promotions.Acts.Controls.Act do
  @moduledoc false

  use GloboTicket.Control

  alias Emu.Ticks
  alias GloboTicket.Promotions.Acts

  def example(attrs \\ %{}) do
    defaults = %{
      id: Identifier.Uuid.Controls.Static.example(),
      title: "Gabriel Iglesias",
      last_updated_ticks: Ticks.zero()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Acts.Act, attrs)
  end

  def generate(attrs \\ %{}) do
    defaults = %{
      id: Identifier.Uuid.Controls.Random.example(),
      title: Faker.Person.name(),
      last_updated_ticks: Ticks.zero()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Acts.Act, attrs)
  end

  defmodule Attrs do
    @moduledoc false

    def valid(attrs \\ %{}) do
      defaults = %{
        title: "Gabriel Iglesias"
      }

      Enum.into(attrs, defaults)
    end

    def invalid(attrs \\ %{}) do
      defaults = %{
        title: nil
      }

      Enum.into(attrs, defaults)
    end
  end
end

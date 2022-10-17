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

  defmodule Attrs do
    @moduledoc false

    def valid(attrs \\ %{}) do
      date_time = ~U[2027-01-01 00:00:00.000000Z]

      defaults = %{
        start_at: Map.take(date_time, [:year, :month, :date, :hour, :minute])
      }

      Enum.into(attrs, defaults)
    end

    def invalid(attrs \\ %{}) do
      defaults = %{}

      Enum.into(attrs, defaults)
    end
  end
end

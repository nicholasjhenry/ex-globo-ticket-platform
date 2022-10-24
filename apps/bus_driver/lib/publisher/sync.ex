defmodule BusDriver.Publisher.Sync do
  @moduledoc false

  def publish(topic, message, opts \\ []) do
    handlers = Keyword.get(opts, :handlers, get_handlers())

    handlers
    |> Enum.filter(fn {handler_topic, _handler} -> handler_topic == topic end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.each(& &1.handle(message))
  end

  defp get_handlers do
    Application.fetch_env!(:bus_driver, :handlers)
  end
end

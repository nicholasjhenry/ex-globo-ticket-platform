defmodule BusDriver do
  @moduledoc false

  @publisher Application.compile_env(:bus_driver, [:publisher], BusDriver.Publisher.Sync)

  defdelegate publish(topic, message, opts \\ []), to: @publisher
end

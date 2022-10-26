defmodule BusDriver.Publisher.Substitute do
  @moduledoc false

  def publish(topic, message, _opts \\ []) do
    send(self(), {topic, message})
  end
end

defmodule BusDriverTest do
  use ExUnit.Case

  test "invokes handlers" do
    handlers = [
      {:subscriptions, __MODULE__}
    ]

    BusDriver.publish(:subscriptions, :test_message, handlers: handlers)

    assert_received {:received, :test_message}
  end

  def handle(message) do
    send(self(), {:received, message})
  end
end

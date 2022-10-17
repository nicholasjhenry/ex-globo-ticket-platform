defmodule BusDriverTest do
  use ExUnit.Case
  doctest BusDriver

  test "greets the world" do
    assert BusDriver.hello() == :world
  end
end

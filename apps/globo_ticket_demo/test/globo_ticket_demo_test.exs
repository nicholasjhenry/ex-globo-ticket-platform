defmodule GloboTicketDemoTest do
  use ExUnit.Case
  doctest GloboTicketDemo

  test "greets the world" do
    assert GloboTicketDemo.hello() == :world
  end
end

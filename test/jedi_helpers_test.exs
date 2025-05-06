defmodule JediHelpersTest do
  use ExUnit.Case
  doctest JediHelpers

  test "greets the world" do
    assert JediHelpers.hello() == :world
  end
end

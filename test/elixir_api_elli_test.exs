defmodule ElixirApiElliTest do
  use ExUnit.Case
  doctest ElixirApiElli

  test "greets the world" do
    assert ElixirApiElli.hello() == :world
  end
end

defmodule ArticulateWookieTest do
  use ExUnit.Case
  doctest ArticulateWookie

  test "greets the world" do
    assert ArticulateWookie.hello() == :world
  end
end

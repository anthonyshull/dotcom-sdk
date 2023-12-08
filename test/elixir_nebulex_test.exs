defmodule DotcomSdkTest do
  use ExUnit.Case
  doctest DotcomSdk

  test "greets the world" do
    assert DotcomSdk.hello() == :world
  end
end

defmodule JediHelpers.MapHelpersTest do
  use ExUnit.Case, async: true

  alias JediHelpers.MapHelpers

  describe "compact_blank/1" do
    test "removes blank values and preserves false and zero" do
      params = %{name: "Leia", note: "  ", tags: [], metadata: %{}, active: false, count: 0}

      assert MapHelpers.compact_blank(params) == %{
               name: "Leia",
               active: false,
               count: 0
             }
    end
  end

  describe "put_if_present/3" do
    test "puts present values" do
      assert MapHelpers.put_if_present(%{}, :name, "Luke") == %{name: "Luke"}
    end

    test "leaves the map unchanged for blank values" do
      assert MapHelpers.put_if_present(%{role: "admin"}, :name, "  ") == %{role: "admin"}
    end
  end
end

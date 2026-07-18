defmodule JediHelpers.ParamHelpersTest do
  use ExUnit.Case, async: true

  alias JediHelpers.ParamHelpers

  describe "fetch_cast/3" do
    test "casts Phoenix string params using an atom key" do
      assert ParamHelpers.fetch_cast(%{"page" => "12"}, :page, :integer) == {:ok, 12}
      assert ParamHelpers.fetch_cast(%{"active" => "true"}, :active, :boolean) == {:ok, true}
    end

    test "prefers an exact atom key when both forms exist" do
      params = %{"page" => "3", page: "2"}

      assert ParamHelpers.fetch_cast(params, :page, :integer) == {:ok, 2}
    end

    test "returns error for missing and invalid values" do
      assert ParamHelpers.fetch_cast(%{}, :page, :integer) == :error
      assert ParamHelpers.fetch_cast(%{"page" => "later"}, :page, :integer) == :error
    end
  end

  describe "get_cast/4" do
    test "returns the cast value or the configured default" do
      assert ParamHelpers.get_cast(%{"page" => "4"}, :page, :integer, 1) == 4
      assert ParamHelpers.get_cast(%{}, :page, :integer, 1) == 1
    end
  end
end

defmodule JediHelpers.FormHelpersTest do
  use ExUnit.Case, async: true
  doctest JediHelpers.FormHelpers

  alias JediHelpers.FormHelpers

  describe "options_for/2" do
    test "uses the selected label field and id" do
      users = [%{id: 1, name: "Leia"}, %{id: 2, name: "Luke"}]

      assert FormHelpers.options_for(users, :name) == [{"Leia", 1}, {"Luke", 2}]
    end
  end

  describe "options_for/3" do
    test "accepts custom fields" do
      users = [%{email: "leia@example.com", slug: "leia"}]

      assert FormHelpers.options_for(users, :email, :slug) == [
               {"leia@example.com", "leia"}
             ]
    end

    test "accepts selector functions" do
      users = [%{id: 1, first_name: "Leia", last_name: "Organa"}]

      assert FormHelpers.options_for(
               users,
               &"#{&1.last_name}, #{&1.first_name}",
               &"user-#{&1.id}"
             ) == [{"Organa, Leia", "user-1"}]
    end

    test "raises for non-map items" do
      assert_raise ArgumentError, ~r/Expected a map or struct/, fn ->
        FormHelpers.options_for([:invalid], :name)
      end
    end
  end
end

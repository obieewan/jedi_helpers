defmodule JediHelpers.BlogPost do
  defstruct title: "", content: ""
end

defmodule JediHelpersTest do
  use ExUnit.Case
  import JediHelpers

  describe "resource_type/1" do
    test "returns the snake_case module name of a struct" do
      assert resource_type(%JediHelpers.BlogPost{}) == "blog_post"
    end
  end

  describe "uri_parse_path/1" do
    test "extracts the path from a URI string" do
      assert uri_parse_path("https://example.com/users/123?ref=home") == "/users/123"
    end

    test "returns nil when no path is present" do
      assert uri_parse_path("https://example.com") == nil
    end
  end

  describe "atom_to_readable_string/1" do
    test "converts single-word atom" do
      assert JediHelpers.atom_to_readable_string(:admin) == "Admin"
    end

    test "converts multi-word atom with underscores" do
      assert JediHelpers.atom_to_readable_string(:user_profile) == "User Profile"
    end

    test "converts complex atom with multiple words" do
      assert JediHelpers.atom_to_readable_string(:super_admin_dashboard) ==
               "Super Admin Dashboard"
    end
  end

  describe "format_name/1" do
    test "formats full name from first_name and last_name" do
      assert JediHelpers.format_name(%{first_name: "Luke", last_name: "Skywalker"}) ==
               "Luke Skywalker"
    end

    test "returns nil when input is nil" do
      assert JediHelpers.format_name(nil) == nil
    end

    test "raises error when keys are missing" do
      assert_raise ArgumentError, fn ->
        JediHelpers.format_name(%{name: "Yoda"})
      end
    end
  end

  describe "format_name/2" do
    test "formats name as Last, First with :last_first style" do
      assert JediHelpers.format_name(%{first_name: "Luke", last_name: "Skywalker"}, :last_first) ==
               "Skywalker, Luke"
    end

    test "defaults to First Last if unknown style" do
      assert JediHelpers.format_name(%{first_name: "Leia", last_name: "Organa"}, :unknown) ==
               "Leia Organa"
    end
  end

  describe "format_name_with_email/1" do
    test "formats name with email" do
      assert JediHelpers.format_name_with_email(%{
               first_name: "Leia",
               last_name: "Organa",
               email: "leia@alderaan.com"
             }) == "Leia Organa - leia@alderaan.com"
    end

    test "raises error if missing fields" do
      assert_raise ArgumentError, fn ->
        JediHelpers.format_name_with_email(%{first_name: "Leia", last_name: "Organa"})
      end
    end
  end

  describe "format_decimal/1" do
    test "formats integer with delimiters and 2 decimal places" do
      assert JediHelpers.format_decimal(1_234_567) == "1,234,567.00"
    end

    test "formats string decimal input" do
      assert JediHelpers.format_decimal("1000.1") == "1,000.10"
    end

    test "returns nil if input is nil" do
      assert JediHelpers.format_decimal(nil) == nil
    end

    test "returns nil if input is empty string" do
      assert JediHelpers.format_decimal("") == nil
    end
  end


describe "format_money/3" do
  test "formats a number with default options" do
    assert JediHelpers.format_money(1000, :php) == "₱1,000.00"
    assert JediHelpers.format_money("1000", :php) == "₱1,000.00"
  end

  test "returns nil if amount is nil" do
    assert JediHelpers.format_money(nil, :php) == nil
  end

  test "formats with symbol: false" do
    assert JediHelpers.format_money(1234.56, :php, symbol: false) == "₱1,234.56"
  end

  test "parses valid decimal string" do
    assert JediHelpers.format_money("1234.56", :php) == "₱1,234.56"
  end

  test "raises error for binary with letters" do
    assert_raise ArgumentError, fn ->
      JediHelpers.format_money("123abc", :php)
    end
  end

  test "raises error for malformed number" do
    assert_raise ArgumentError, fn ->
      JediHelpers.format_money("12.34.56", :php)
    end
  end
end
end

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

  describe "format_money/2" do
    test "formats a valid amount as a currency string" do
      assert format_money(1200, :php) == "₱1,200.00"
    end

    test "returns nil if the amount is nil" do
      assert format_money(nil, :php) == nil
    end
  end
end

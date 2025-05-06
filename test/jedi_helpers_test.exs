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
end

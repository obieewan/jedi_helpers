defmodule JediHelpers.DateUtilsTest do
  use ExUnit.Case, async: true
  alias JediHelpers.DateUtils

  describe "to_date/1" do
    test "returns nil for empty string" do
      assert DateUtils.to_date("") == nil
    end

    test "returns nil for '0'" do
      assert DateUtils.to_date("0") == nil
    end

    test "returns the same date for Date input" do
      date = ~D[2023-12-25]
      assert DateUtils.to_date(date) == date
    end

    test "parses ISO-like date strings" do
      assert DateUtils.to_date("2023-1-5") == ~D[2023-01-05]
      assert DateUtils.to_date("1999-12-31") == ~D[1999-12-31]
    end

    test "parses Excel serial number strings" do
      assert DateUtils.to_date("40135") == ~D[2009-11-18]
    end

    test "handles strings with whitespace" do
      assert DateUtils.to_date(" 40135 ") == ~D[2009-11-18]
      assert DateUtils.to_date(" 2023-1-5 ") == ~D[2023-01-05]
    end

    test "returns nil for malformed strings" do
      assert DateUtils.to_date("abc") == nil
      assert DateUtils.to_date("2023-13-01") == nil
      assert DateUtils.to_date("2023-02-30") == nil
    end
  end
end

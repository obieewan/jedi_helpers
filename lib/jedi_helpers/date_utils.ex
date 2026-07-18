defmodule JediHelpers.DateUtils do
  @moduledoc """
  Converts common spreadsheet and form date values into `Date` structs.

  Invalid values return `nil`, making the helper convenient for optional import
  fields where callers prefer a nullable result over an exception.
  """

  @doc """
  Parses a variety of date formats into a `Date` struct.

  ## Supported inputs

  * `""` or `"0"` – returns `nil`
  * A `Date` struct – returns the date itself
  * Excel serial date string (e.g. `"40135"`) – returns the corresponding `Date`
  * ISO-ish strings (e.g. `"2023-1-5"`, `"2023-01-05"`) – returns the parsed `Date`
  * Strings with leading/trailing whitespace are trimmed
  * Invalid or malformed strings return `nil`

  ## Use cases and results

  Convert an Excel serial date during a CSV or spreadsheet import:

      iex> JediHelpers.DateUtils.to_date("40135")
      ~D[2009-11-18]

  Normalize a non-zero-padded date received from a form:

      iex> JediHelpers.DateUtils.to_date("2024-1-9")
      ~D[2024-01-09]

  Existing dates pass through unchanged, while blank and invalid values become
  `nil`:

      iex> JediHelpers.DateUtils.to_date(~D[2020-05-10])
      ~D[2020-05-10]

      iex> JediHelpers.DateUtils.to_date("")
      nil

      iex> JediHelpers.DateUtils.to_date("not a date")
      nil

  """
  @spec to_date(term()) :: Date.t() | nil
  def to_date(""), do: nil

  def to_date("0"), do: nil

  def to_date(%Date{} = date), do: date

  def to_date(date_string) when is_binary(date_string) do
    date_string = String.trim(date_string)

    cond do
      # Handle Excel serial number string
      Regex.match?(~r/^\d+$/, date_string) ->
        serial = String.to_integer(date_string)
        # Excel's date system starts at 1900-01-01 as day 1,
        # and incorrectly includes 1900-02-29 as a valid date (leap year bug),
        # so we subtract 2 to align with actual dates.
        Date.add(~D[1900-01-01], serial - 2)

      String.contains?(date_string, "-") ->
        case String.split(date_string, "-") do
          [year, month, day] ->
            iso_date =
              "#{year}-#{String.pad_leading(month, 2, "0")}-#{String.pad_leading(day, 2, "0")}"

            case Date.from_iso8601(iso_date) do
              {:ok, date} -> date
              _ -> nil
            end

          _ ->
            nil
        end

      true ->
        nil
    end
  end

  def to_date(_), do: nil
end

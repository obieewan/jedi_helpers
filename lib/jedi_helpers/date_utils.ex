defmodule JediHelpers.DateUtils do
  @doc """
Parses a variety of date formats into a `Date` struct.

  ## Supported inputs

  * `""` or `"0"` – returns `nil`
  * A `Date` struct – returns the date itself
  * Excel serial date string (e.g. `"40135"`) – returns the corresponding `Date`
  * ISO-ish strings (e.g. `"2023-1-5"`, `"2023-01-05"`) – returns the parsed `Date`
  * Strings with leading/trailing whitespace are trimmed
  * Invalid or malformed strings return `nil`

  ## Examples

  iex> to_date("40135")
  ~D[2009-11-18]

  iex> to_date("2024-1-9")
  ~D[2024-01-09]

  iex> to_date("")
  nil

  iex> to_date(%Date{year: 2020, month: 5, day: 10})
  ~D[2020-05-10]

  iex> to_date("not a date")
  nil

    """
  def to_date(""), do: nil

  def to_date("0"), do: nil

  def to_date(%Date{} = date), do: date

  def to_date(date_string) when is_binary(date_string) do
    date_string = String.trim(date_string)

    cond do
      # Handle Excel serial number string
      Regex.match?(~r/^\d+$/, date_string) ->
        serial = String.to_integer(date_string)
        Date.add(~D[1900-01-01], serial - 2) # Adjust for Excel leap year bug

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


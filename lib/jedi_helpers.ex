defmodule JediHelpers do
  @moduledoc """
  Documentation for `JediHelpers`.
  """

  @doc """
  Returns the underscored (snake_case) name of a struct's module as a string.

  Useful for generating type identifiers from structs, especially in APIs or dynamic logic.

  ## Example

      iex> resource_type(%JediHelpers.BlogPost{})
      "blog_post"

  ## Parameters:
  - `resource` (`struct`): Any Elixir struct.

  ## Returns:
  - `String.t()`: The snake_case name of the struct's module (last segment only).
  """
  @spec resource_type(struct()) :: String.t()
  def resource_type(%module{} = _resource) do
    module
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
  end

  @doc """
  Extracts the path segment from a URI string.

  Useful for isolating the path portion of a full URL (e.g. `/users/123`).

  ## Example

      iex> uri_parse_path("https://example.com/users/123?ref=home")
      "/users/123"

  ## Parameters:
  - `uri` (`String.t()`): A URI string.

  ## Returns:
  - `String.t()` or `nil`: The path component of the URI, or `nil` if absent.
  """
  @spec uri_parse_path(String.t()) :: String.t() | nil
  def uri_parse_path(uri) do
    URI.parse(uri).path
  end

  @doc """
  Converts an atom into a human-readable string by title-casing its segments.

  Useful for displaying labels or headings derived from atoms.

  ## Examples

      iex> JediHelpers.atom_to_readable_string(:user_profile)
      "User Profile"

      iex> JediHelpers.atom_to_readable_string(:admin)
      "Admin"
  """
  @spec atom_to_readable_string(atom()) :: String.t()
  def atom_to_readable_string(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @doc """
  Formats a user's full name as `"First Last"`.

  Returns `nil` if the input is `nil`.

  ## Examples

      iex> format_name(%{first_name: "Luke", last_name: "Skywalker"})
      "Luke Skywalker"
  """
  def format_name(nil), do: nil

  def format_name(%{first_name: first, last_name: last}) do
    "#{first} #{last}"
  end

  @doc """
  Formats a user's name as `"Last, First"` if `:last_first` style is passed.

  ## Examples

      iex> format_name(%{first_name: "Luke", last_name: "Skywalker"}, :last_first)
      "Skywalker, Luke"
  """
  def format_name(user, style \\ :default)

  def format_name(%{first_name: first, last_name: last}, :last_first) do
    "#{last}, #{first}"
  end

  def format_name(%{first_name: first, last_name: last}, _style) do
    "#{first} #{last}"
  end

  def format_name(user, _style) do
    raise ArgumentError,
          "Expected a struct or map with :first_name and :last_name, got: #{inspect(user)}"
  end

  @doc """
  Formats a user's full name with email as `"First Last - email@example.com"`.

  ## Examples

      iex> format_name_with_email(%{first_name: "Leia", last_name: "Organa", email: "leia@alderaan.com"})
      "Leia Organa - leia@alderaan.com"
  """
  def format_name_with_email(%{first_name: first, last_name: last, email: email}) do
    "#{first} #{last} - #{email}"
  end

  def format_name_with_email(user) do
    raise ArgumentError,
          "Expected a struct or map with :first_name, :last_name, and :email, got: #{inspect(user)}"
  end

  @doc """
  Formats a decimal or numeric input by:

    - Converting it to a `Decimal`
    - Rounding to 2 decimal places
    - Converting to a string
    - Adding thousands separators (e.g., `"1,234.56"`)

  Returns `nil` if the input is `nil`.

  ## Examples

      iex> format_decimal(1234567.891)
      "1,234,567.89"

      iex> format_decimal("1000.1")
      "1,000.10"

      iex> format_decimal(nil)
      nil

  ## Requirements

  Requires the `:decimal` and `:number` libraries.

  """
  def format_decimal(nil), do: nil

  def format_decimal(""), do: nil

  def format_decimal(value) do
    value
    |> Decimal.new()
    |> Decimal.round(2)
    |> Decimal.to_string()
    |> Number.Delimit.number_to_delimited()
  end

  @doc """
  Formats a given amount into a currency string using `Money`.

  ## Parameters

    - `amount`: A number representing the amount to format. Supported types:
      - `Money` struct (used directly)
      - `Decimal` (e.g., from Ecto fields)
      - `integer` (treated as the smallest unit, like cents)
      - `float`
      - `string` (parsed into a Money amount)
    - `currency`: A string or atom representing the ISO 4217 currency code (e.g., `:php` for Philippine Peso).
    - `opts` (optional): A keyword list of formatting options passed to `Money.to_string/2`.

  ## Returns

    - A formatted currency string on success.
    - Raises a `RuntimeError` on formatting failure.
    - Raises an `ArgumentError` for unsupported amount types.
    - Returns `nil` if the `amount` is `nil`.

  ## Examples

      iex> format_money(1000, :php)
      "₱1,000.00"

      iex> format_money(nil, :php)
      nil

      iex> format_money(Decimal.new("1234.56"), :usd)
      "$1,234.56"

      iex> format_money(1234.56, :php, symbol: false)
      "1,234.56 PHP"

  ## Formatting Options

  The `opts` are forwarded to `Money.to_string/2`.  
  Refer to the [ex_money Money.to_string/2 documentation](https://hexdocs.pm/ex_money/Money.html#to_string/2) for the full list of supported options.
  """

  def format_money(amount, currency_code, opts \\ [])

  def format_money(nil, _currency_code, _opts), do: nil

  def format_money(amount, currency_code, opts) do
    money =
      cond do
        is_struct(amount, Money) ->
          amount

        is_struct(amount, Decimal) ->
          Money.new(amount, currency_code)

        is_integer(amount) ->
          Money.new(amount, currency_code)

        is_binary(amount) ->
          case Decimal.parse(amount) do
            {decimal, ""} -> Money.new(decimal, currency_code)
            {_decimal, _rest} -> raise ArgumentError, "Invalid binary amount: #{inspect(amount)}"
            :error -> raise ArgumentError, "Invalid binary amount: #{inspect(amount)}"
          end

        is_float(amount) ->
          Money.from_float(amount, currency_code)

        true ->
          raise ArgumentError, "Invalid amount type: #{inspect(amount)}"
      end

    case Money.to_string(money, opts) do
      {:ok, formatted} -> formatted
      {:error, reason} -> raise RuntimeError, "Failed to format money: #{inspect(reason)}"
    end
  end

  @doc """
  Trims the `:description` field of the given resource to a maximum length.

  ## Parameters

    - resource: A map that must contain a non-nil, binary `:description` key.
    - max_length: The maximum length of the trimmed description (default is 50).

  ## Examples

      iex> trim_description(%{description: "This is a very long description that needs trimming"}, 10)
      "This is a "

      iex> trim_description(%{description: "Short"}, 10)
      "Short"

  ## Raises

  Raises `ArgumentError` if the `resource` does not contain a non-nil, binary `:description` field.
  """
  def trim_description(resource, max_length \\ 50)

  def trim_description(%{description: description}, max_length)
      when not is_nil(description) and is_binary(description) do
    String.slice(description, 0, max_length)
  end

  def trim_description(resource, _max_length) do
    raise ArgumentError, """
    Invalid argument for trim_description/2.

    Expected a map with a non-nil, binary `:description` key.

    Example:
      %{description: "some string"}

    Received: #{inspect(resource)}
    """
  end

  def number_to_words(number) do
    {:ok, word} = JediHelpers.Internal.Cldr.Number.to_string(number, format: :spellout_verbose)

    word
  end
end

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

  def format_money(amount, _currency, opts \\ [])

  def format_money(nil, _currency, _opts), do: nil

  def format_money(amount, currency, opts) do
      amount
      |> Money.new(currency)
      |> Money.to_string(opts)
    |> case do
      {:ok, formatted_money} ->
        formatted_money

      {:error, reason} ->
        reason
    end

  end
end

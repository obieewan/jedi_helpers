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
  Formats a numeric amount as a currency string using `Money`.

  Returns `nil` if the amount is `nil`.

  ## Example

      iex> format_money(1200, :php)
      "₱1,200.00"

  See [Money.Currency.known_current_currencies/0](https://hexdocs.pm/ex_money/Money.Currency.html#known_current_currencies/0)
  for valid currency atoms.
  """
  @spec format_money(number() | nil, atom()) :: String.t() | nil
  def format_money(nil, _currency), do: nil

  def format_money(amount, currency) do
    {:ok, formatted_money} =
      amount
      |> Money.new(currency)
      |> Money.to_string()

    formatted_money
  end
end

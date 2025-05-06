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
end

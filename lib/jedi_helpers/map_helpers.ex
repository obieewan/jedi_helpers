defmodule JediHelpers.MapHelpers do
  @moduledoc """
  Helpers for building maps and Phoenix params without repeated conditionals.
  """

  @doc """
  Removes entries whose values are blank according to `JediHelpers.blank?/1`.

  The operation is shallow and preserves meaningful values such as `false` and
  `0`.

  ## Example

      iex> compact_blank(%{name: "Leia", note: "  ", active: false})
      %{name: "Leia", active: false}
  """
  @spec compact_blank(map()) :: map()
  def compact_blank(map) when is_map(map) do
    Map.reject(map, fn {_key, value} -> JediHelpers.blank?(value) end)
  end

  @doc """
  Puts a value into a map only when it is present.

  ## Examples

      iex> put_if_present(%{}, :email, "leia@example.com")
      %{email: "leia@example.com"}

      iex> put_if_present(%{role: "admin"}, :email, "  ")
      %{role: "admin"}
  """
  @spec put_if_present(map(), term(), term()) :: map()
  def put_if_present(map, key, value) when is_map(map) do
    if JediHelpers.present?(value), do: Map.put(map, key, value), else: map
  end
end

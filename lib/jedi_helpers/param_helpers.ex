defmodule JediHelpers.ParamHelpers do
  @moduledoc """
  Helpers for safely reading and casting controller and LiveView params.
  """

  @doc """
  Fetches a param and casts it with `Ecto.Type.cast/2`.

  When `key` is an atom, both the atom key and its string equivalent are
  accepted, which makes the helper work with internal maps and Phoenix params.
  Returns `:error` when the key is absent or the value cannot be cast.

  ## Examples

      iex> fetch_cast(%{"page" => "12"}, :page, :integer)
      {:ok, 12}

      iex> fetch_cast(%{"active" => "not-a-boolean"}, :active, :boolean)
      :error
  """
  @spec fetch_cast(map(), atom() | String.t(), Ecto.Type.t()) :: {:ok, term()} | :error
  def fetch_cast(params, key, type) when is_map(params) and (is_atom(key) or is_binary(key)) do
    with {:ok, value} <- fetch_param(params, key),
         {:ok, cast_value} <- Ecto.Type.cast(type, value) do
      {:ok, cast_value}
    else
      _error -> :error
    end
  end

  @doc """
  Returns a cast param or a default when it is missing or invalid.

  ## Example

      iex> get_cast(%{"page" => "invalid"}, :page, :integer, 1)
      1
  """
  @spec get_cast(map(), atom() | String.t(), Ecto.Type.t(), term()) :: term()
  def get_cast(params, key, type, default \\ nil) do
    case fetch_cast(params, key, type) do
      {:ok, value} -> value
      :error -> default
    end
  end

  defp fetch_param(params, key) do
    case Map.fetch(params, key) do
      {:ok, value} -> {:ok, value}
      :error when is_atom(key) -> Map.fetch(params, Atom.to_string(key))
      :error -> :error
    end
  end
end

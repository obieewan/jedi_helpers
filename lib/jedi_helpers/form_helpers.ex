defmodule JediHelpers.FormHelpers do
  @moduledoc """
  Builds `{label, value}` tuples accepted by Phoenix form select components.
  """

  @doc """
  Generates `{label, value}` tuples for a list of maps or structs to be used in dropdowns.

  Labels and values may be field names or unary functions. The value defaults
  to the `:id` field.

  ## Use case and result

  Use a display field as the label and each record's `:id` as the submitted
  value:

      iex> users = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
      iex> JediHelpers.FormHelpers.options_for(users, :name)
      [{"Alice", 1}, {"Bob", 2}]

      iex> JediHelpers.FormHelpers.options_for(users, &String.upcase(&1.name), :id)
      [{"ALICE", 1}, {"BOB", 2}]

  The result can be passed directly to a Phoenix `<.input type="select">`
  `options` attribute. Raises `ArgumentError` when an item is not a map or when
  a selector is invalid, and `KeyError` when a selected field is absent.
  """
  @spec options_for([map()], atom() | (map() -> term())) :: [{term(), term()}]
  def options_for(list, label)

  def options_for(list, label)
      when is_list(list) and (is_atom(label) or is_function(label, 1)) do
    options_for(list, label, :id)
  end

  def options_for(list, label) do
    raise ArgumentError,
          "Expected a list and an atom or function, got: list=#{inspect(list)}, label=#{inspect(label)}"
  end

  @doc """
  Generates option tuples using configurable label and value selectors.

  Each selector can be an atom naming a map field or a unary function. This is
  useful when a select submits a slug instead of an ID or needs a composite
  label.

  ## Use case and result

      iex> users = [
      ...>   %{id: 1, first_name: "Leia", last_name: "Organa", slug: "leia"},
      ...>   %{id: 2, first_name: "Luke", last_name: "Skywalker", slug: "luke"}
      ...> ]
      iex> JediHelpers.FormHelpers.options_for(
      ...>   users,
      ...>   &"#{&1.last_name}, #{&1.first_name}",
      ...>   :slug
      ...> )
      [{"Organa, Leia", "leia"}, {"Skywalker, Luke", "luke"}]
  """
  @spec options_for([map()], atom() | (map() -> term()), atom() | (map() -> term())) ::
          [{term(), term()}]
  def options_for(list, label, value)

  def options_for(list, label, value)
      when is_list(list) and (is_atom(label) or is_function(label, 1)) and
             (is_atom(value) or is_function(value, 1)) do
    Enum.map(list, fn
      item when is_map(item) -> {select(item, label), select(item, value)}
      item -> raise ArgumentError, "Expected a map or struct, got: #{inspect(item)}"
    end)
  end

  def options_for(list, label, value) do
    raise ArgumentError,
          "Expected a list and atom or function selectors, got: list=#{inspect(list)}, label=#{inspect(label)}, value=#{inspect(value)}"
  end

  defp select(item, field) when is_atom(field), do: Map.fetch!(item, field)
  defp select(item, selector), do: selector.(item)
end

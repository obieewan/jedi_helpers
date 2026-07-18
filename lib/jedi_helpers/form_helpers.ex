defmodule JediHelpers.FormHelpers do
  @moduledoc """
  Helper functions for form inputs and options.
  """

  @doc """
  Generates `{label, value}` tuples for a list of maps or structs to be used in dropdowns.

  Labels and values may be field names or unary functions. The value defaults
  to the `:id` field.

  ## Examples

      iex> users = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
      iex> JediHelpers.FormHelpers.options_for(users, :name)
      [{"Alice", 1}, {"Bob", 2}]

      iex> JediHelpers.FormHelpers.options_for(users, &String.upcase(&1.name), :id)
      [{"ALICE", 1}, {"BOB", 2}]

  Raises if an element is not a map or struct, or if the arguments are invalid.
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

  Each selector can be an atom naming a map field or a unary function.
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

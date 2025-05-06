defmodule JediHelpers.FormHelpers do
  @moduledoc """
  Helper functions for form inputs and options.
  """

  @doc """
  Generates `{label, id}` tuples for a list of maps or structs to be used in dropdowns.

  ## Examples

      iex> users = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
      iex> JediHelpers.FormHelpers.options_for(users, :name)
      [{"Alice", 1}, {"Bob", 2}]

  Raises if an element is not a map or struct, or if the arguments are invalid.
  """
  def options_for(list, label_field) when is_list(list) and is_atom(label_field) do
    Enum.map(list, fn element ->
      cond do
        is_map(element) or is_struct(element) ->
          {Map.get(element, label_field), element.id}

        true ->
          raise ArgumentError, "Each item in the list must be a map or struct"
      end
    end)
  end

  def options_for(list, label_field) do
    raise ArgumentError,
          "Expected a list and an atom, got: list=#{inspect(list)}, label_field=#{inspect(label_field)}"
  end
end

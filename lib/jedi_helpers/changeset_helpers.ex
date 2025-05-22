defmodule JediHelpers.ChangesetHelpers do
  @moduledoc """
  Provides helper functions for trimming whitespace and validating string fields
  in Ecto changesets. Particularly useful for ensuring uniqueness and formatting
  of string inputs before applying database constraints.
  """

  import Ecto.Changeset

  @field_type :string

  @doc """
  Trims leading and trailing whitespace from one or more string fields in the changeset.
  Ensures consistency and helps maintain uniqueness constraints (e.g., on `citext` fields).

  ## Options

  - `:max` (`integer`): Maximum allowed length after trimming. If exceeded, a validation error is added. Default is 255.
  - `:enforce_unique` (`boolean`): When set to `true`, adds a `unique_constraint/3` to the field. Default is `false`.

  ## Examples

      changeset
      |> trim_whitespace(:username, max: 50, enforce_unique: true)

  ## Parameters

  - `changeset` (`Ecto.Changeset.t()`): The changeset containing the field(s) to be processed.
  - `field` (`atom()` or `[atom()]`): The field(s) to trim.
  - `opts` (`keyword()`): Options for trimming and validation.

  ## Returns

  - An updated `Ecto.Changeset.t()` with trimmed values and optional validations.
  """
  @spec trim_whitespace(Ecto.Changeset.t(), atom() | [atom()], keyword()) :: Ecto.Changeset.t()
  def trim_whitespace(changeset, keys, opts \\ [])

  def trim_whitespace(changeset, key, opts) when is_atom(key) do
    max = Keyword.get(opts, :max, 255)
    enforce_unique? = Keyword.get(opts, :enforce_unique, false)

    case Map.get(changeset.types, key) do
      type when type == @field_type ->
        case fetch_field(changeset, key) do
          {_source, nil} ->
            changeset

          {_source, value} when is_binary(value) ->
            new_value = String.trim(value)

            changeset
            |> put_change(key, new_value)
            |> maybe_enforce_unique(key, enforce_unique?)
            |> validate_length(key, max: max)

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  def trim_whitespace(changeset, keys, opts) when is_list(keys) do
    Enum.reduce(keys, changeset, fn key, acc ->
      trim_whitespace(acc, key, opts)
    end)
  end

  defp maybe_enforce_unique(changeset, key, true), do: unique_constraint(changeset, key)
  defp maybe_enforce_unique(changeset, _key, false), do: changeset
end

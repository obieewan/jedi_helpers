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

  You may specify a `:max` option to validate that the trimmed value does not exceed
  the given length. If it does, a validation error is added.

  ## Examples

  changeset
  |> trim_whitespace(:username, max: 50)
  |> unique_constraint(:username)

  changeset
  |> trim_whitespace([:first_name, :last_name])

  ## Options

  * `:max` - maximum allowed length for the trimmed string (default: 255)

  ## Parameters

  * `changeset` - an `Ecto.Changeset.t()` to process
    * `key` or `keys` - atom or list of atoms naming the field(s) to trim
    * `opts` - keyword list of options

  ## Returns

  * An updated `Ecto.Changeset.t()` with trimmed fields and length validations applied.
  """
  @spec trim_whitespace(Ecto.Changeset.t(), atom() | [atom()], keyword()) :: Ecto.Changeset.t()
  def trim_whitespace(changeset, keys, opts \\ [])

  def trim_whitespace(changeset, key, opts) when is_atom(key) do
    max = Keyword.get(opts, :max, 255)

    case Map.get(changeset.types, key) do
      type when type == @field_type ->
        case fetch_field(changeset, key) do
          {_source, nil} ->
            changeset

          {_source, value} when is_binary(value) ->
            new_value = String.trim(value)

            changeset
            |> put_change(key, new_value)
            |> unique_constraint(key)
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
end

defmodule JediHelpers.ChangesetHelpers do
  import Ecto.Changeset

  @doc """
  Trims leading and trailing whitespaces from the specified fields in the changeset.
  This ensures consistency and helps maintain uniqueness, especially for `citext` fields.

  You can also specify a `max` length in the `opts` to validate that the field's length
  after trimming does not exceed the specified value. If it exceeds, a validation error is added.

  ## Example

  changeset
  |> trim_whitespace(:username, max: 50)
  |> unique_constraint(:username)

  ## Parameters:
  - `changeset` (`Ecto.Changeset.t()`): The changeset containing the field to be processed.
  - `field` (`atom()` or `[atom()]`): The field(s) to trim.
  - `opts` (`keyword()`): Options for the function:
  - `:max` (`integer()`): The maximum allowed length after trimming. Adds a validation error if exceeded.

  ## Returns:
  - An updated `Ecto.Changeset.t()` with the trimmed field and potential validation error if the length exceeds `max`.
  """

  @field_type :string

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
            |> validate_length(key, max: max)

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  def trim_whitespace(changeset, keys, opts) when is_list(keys) do
    Enum.reduce(keys, changeset, fn key, changeset ->
      trim_whitespace(changeset, key, opts)
    end)
  end
end

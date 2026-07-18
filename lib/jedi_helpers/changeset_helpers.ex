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

      changeset
      |> trim_whitespace(:username, enforce_unique: true)

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

    cond do
      Map.get(changeset.types, key) == @field_type ->
        changeset
        |> update_change(key, fn
          val when is_binary(val) -> String.trim(val)
          val -> val
        end)
        |> maybe_enforce_unique(key, enforce_unique?)
        |> validate_length(key, max: max)

      true ->
        changeset
    end
  end

  def trim_whitespace(changeset, keys, opts) when is_list(keys) do
    Enum.reduce(keys, changeset, fn key, acc ->
      trim_whitespace(acc, key, opts)
    end)
  end

  @doc """
  Trims string changes and converts blank strings to `nil` by default.

  This is useful for optional form fields where whitespace-only input should be
  stored as `nil`. Non-string fields and fields without a change are left alone.

  Set `:empty_to_nil` to `false` to retain an empty string after trimming.

  ## Examples

      changeset
      |> normalize_strings([:first_name, :last_name])

      changeset
      |> normalize_strings(:reference, empty_to_nil: false)
  """
  @spec normalize_strings(Ecto.Changeset.t(), atom() | [atom()], keyword()) ::
          Ecto.Changeset.t()
  def normalize_strings(changeset, fields, opts \\ [])

  def normalize_strings(changeset, field, opts) when is_atom(field) do
    if Map.get(changeset.types, field) == @field_type do
      empty_to_nil? = Keyword.get(opts, :empty_to_nil, true)

      update_change(changeset, field, fn
        value when is_binary(value) -> normalize_string(value, empty_to_nil?)
        value -> value
      end)
    else
      changeset
    end
  end

  def normalize_strings(changeset, fields, opts) when is_list(fields) do
    Enum.reduce(fields, changeset, &normalize_strings(&2, &1, opts))
  end

  @doc """
  Validates that at least one of the given fields has a non-blank value.

  By default, the error is attached to the first field. Use `:error_field` and
  `:message` to customize the resulting changeset error.

  ## Example

      changeset
      |> validate_any_required([:email, :phone],
        error_field: :email,
        message: "email or phone is required"
      )
  """
  @spec validate_any_required(Ecto.Changeset.t(), [atom()], keyword()) :: Ecto.Changeset.t()
  def validate_any_required(changeset, fields, opts \\ [])

  def validate_any_required(changeset, [_ | _] = fields, opts) do
    if Enum.any?(fields, &present?(get_field(changeset, &1))) do
      changeset
    else
      error_field = Keyword.get(opts, :error_field, hd(fields))
      message = Keyword.get(opts, :message, "at least one field must be present")
      add_error(changeset, error_field, message, validation: :required)
    end
  end

  def validate_any_required(_changeset, [], _opts) do
    raise ArgumentError, "validate_any_required/3 expects at least one field"
  end

  defp maybe_enforce_unique(changeset, key, true), do: unique_constraint(changeset, key)
  defp maybe_enforce_unique(changeset, _key, false), do: changeset

  defp normalize_string(value, empty_to_nil?) do
    case String.trim(value) do
      "" when empty_to_nil? -> nil
      normalized -> normalized
    end
  end

  defp present?(value),
    do: not (is_nil(value) or value == "" or (is_binary(value) and String.trim(value) == ""))
end

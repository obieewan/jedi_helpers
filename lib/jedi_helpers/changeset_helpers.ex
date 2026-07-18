defmodule JediHelpers.ChangesetHelpers do
  @moduledoc """
  Normalization and validation helpers for Ecto changesets.

  These helpers are intended for schema `changeset/2` pipelines that receive
  browser form input and need consistent values before persistence.
  """

  import Ecto.Changeset

  @field_type :string

  @doc """
  Trims leading and trailing whitespace from one or more string fields.

  The helper also validates the post-trim length and can attach an Ecto unique
  constraint. Non-string fields are ignored.

  ## Options

  - `:max` - maximum allowed length after trimming; defaults to `255`.
  - `:enforce_unique` - adds `unique_constraint/3`; defaults to `false`.

  ## Use case and result

  A registration changeset can normalize a username before validating or
  inserting it:

      types = %{username: :string}

      result =
        {%{}, types}
        |> Ecto.Changeset.cast(%{"username" => "  leia  "}, [:username])
        |> JediHelpers.ChangesetHelpers.trim_whitespace(:username,
          max: 50,
          enforce_unique: true
        )

      Ecto.Changeset.get_change(result, :username)
      # => "leia"

      result.constraints
      # => [%{constraint: "username", field: :username, match: :exact,
      #      type: :unique, error_message: "has already been taken",
      #      error_type: :unique}]

  When the trimmed value exceeds `:max`, the result is invalid rather than
  truncated:

      result =
        {%{}, types}
        |> Ecto.Changeset.cast(%{"username" => "  too-long  "}, [:username])
        |> JediHelpers.ChangesetHelpers.trim_whitespace(:username, max: 4)

      result.valid?
      # => false
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
  Trims string changes and converts whitespace-only strings to `nil` by default.

  This is useful for optional form fields where whitespace-only input should be
  stored as `nil`. Non-string fields and fields without a change are left alone.

  Set `:empty_to_nil` to `false` to retain an empty string after trimming.

  ## Use case and result

  An optional profile form can store meaningful names while normalizing an
  empty email field to `nil`:

      types = %{name: :string, email: :string}

      result =
        {%{}, types}
        |> Ecto.Changeset.cast(%{"name" => "  Leia  ", "email" => "   "},
          [:name, :email]
        )
        |> JediHelpers.ChangesetHelpers.normalize_strings([:name, :email])

      result.changes
      # => %{email: nil, name: "Leia"}

  With `empty_to_nil: false`, whitespace-only input becomes `""` instead.
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

  ## Use case and result

  A contact form can accept either an email address or a phone number:

      types = %{email: :string, phone: :string}

      result =
        {%{}, types}
        |> Ecto.Changeset.cast(%{}, [:email, :phone])
        |> JediHelpers.ChangesetHelpers.validate_any_required([:email, :phone],
          error_field: :email,
          message: "email or phone is required"
        )

      result.valid?
      # => false

      result.errors[:email]
      # => {"email or phone is required", [validation: :required]}

  If either field contains a value, the changeset remains valid.
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

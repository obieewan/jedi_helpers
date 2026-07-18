defmodule JediHelpers.ChangesetHelpersTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias JediHelpers.ChangesetHelpers

  defmodule TestStruct do
    use Ecto.Schema

    embedded_schema do
      field(:name, :string)
      field(:email, :string)
    end
  end

  describe "trim_whitespace/3" do
    test "trims leading and trailing whitespace from a string field" do
      changeset =
        %TestStruct{}
        |> cast(%{name: "  John Doe  "}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name])

      assert get_field(changeset, :name) == "John Doe"
    end

    test "does nothing when there is no whitespace" do
      changeset =
        %TestStruct{}
        |> cast(%{name: "John Doe"}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name])

      assert get_field(changeset, :name) == "John Doe"
    end

    test "handles nil values gracefully" do
      changeset =
        %TestStruct{}
        |> cast(%{name: nil}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name])

      assert get_field(changeset, :name) == nil
    end

    test "enforces max length when trimming" do
      long_value = "  This is a very long name that should be truncated  "

      changeset =
        %TestStruct{}
        |> cast(%{name: long_value}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name], max: 10)

      # The test here is for validation, not truncation
      assert [
               name:
                 {"should be at most %{count} character(s)",
                  [count: 10, validation: :length, kind: :max, type: :string]}
             ] = changeset.errors
    end

    test "skips non-string values" do
      changeset =
        {%{}, %{name: :any}}
        |> cast(%{name: 12345}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name])

      assert get_field(changeset, :name) == 12345
    end

    test "skips boolean values" do
      changeset =
        {%{}, %{name: :any}}
        |> cast(%{name: true}, [:name])
        |> ChangesetHelpers.trim_whitespace([:name])

      assert get_field(changeset, :name) == true
    end
  end

  describe "normalize_strings/3" do
    test "trims fields and converts whitespace-only changes to nil" do
      changeset =
        %TestStruct{}
        |> cast(%{name: "  Leia  ", email: "   "}, [:name, :email])
        |> ChangesetHelpers.normalize_strings([:name, :email])

      assert get_change(changeset, :name) == "Leia"
      assert get_change(changeset, :email) == nil
    end

    test "can retain an empty string" do
      changeset =
        %TestStruct{}
        |> cast(%{name: "   "}, [:name], empty_values: [])
        |> ChangesetHelpers.normalize_strings(:name, empty_to_nil: false)

      assert get_change(changeset, :name) == ""
    end
  end

  describe "validate_any_required/3" do
    test "accepts a non-blank value in any field" do
      changeset =
        %TestStruct{}
        |> cast(%{email: "luke@example.com"}, [:name, :email])
        |> ChangesetHelpers.validate_any_required([:name, :email])

      assert changeset.valid?
    end

    test "adds a customizable error when all fields are blank" do
      changeset =
        %TestStruct{}
        |> cast(%{}, [:name, :email])
        |> ChangesetHelpers.validate_any_required([:name, :email],
          error_field: :email,
          message: "name or email is required"
        )

      assert {"name or email is required", [validation: :required]} =
               changeset.errors[:email]
    end

    test "requires at least one field" do
      assert_raise ArgumentError, fn ->
        %TestStruct{}
        |> change()
        |> ChangesetHelpers.validate_any_required([])
      end
    end
  end
end

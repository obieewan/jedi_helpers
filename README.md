# JediHelpers

A collection of general-purpose helpers for Elixir projects, designed to make your codebase cleaner and more reusable. Includes utilities for working with changesets and common functional patterns.

## Features

- Changeset string trimming and blank-to-`nil` normalization.
- Validation that at least one of several changeset fields is present.
- Select-option generation with field or function selectors.
- Date parsing, number and money formatting, and common display helpers.

## Usage

Each public function includes a use case and its resulting value in the API
documentation. A few common Phoenix examples are shown below.

### Normalize form input

```elixir
types = %{name: :string, email: :string}

changeset =
  {%{}, types}
  |> Ecto.Changeset.cast(%{"name" => "  Leia  ", "email" => "   "}, [:name, :email])
  |> JediHelpers.ChangesetHelpers.normalize_strings([:name, :email])

changeset.changes
# => %{email: nil, name: "Leia"}
```

### Build select options

```elixir
users = [%{id: 1, name: "Leia"}, %{id: 2, name: "Luke"}]

JediHelpers.FormHelpers.options_for(users, :name)
# => [{"Leia", 1}, {"Luke", 2}]
```

### Parse imported dates

```elixir
JediHelpers.DateUtils.to_date("2024-1-9")
# => ~D[2024-01-09]

JediHelpers.DateUtils.to_date("invalid")
# => nil
```

### Format values for display

```elixir
JediHelpers.format_decimal("1234.5")
# => "1,234.50"

JediHelpers.format_money("1234.56", :php)
# => "₱1,234.56"

JediHelpers.number_to_words(42)
# => "forty-two"
```

## Installation

Add `:jedi_helpers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jedi_helpers, "~> 0.3.1"}
  ]
end
```

Generate the complete API documentation locally with:

```shell
mix docs
```

Published documentation is available on [HexDocs](https://hexdocs.pm/jedi_helpers).

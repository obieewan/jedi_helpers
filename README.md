# JediHelpers

A collection of general-purpose helpers for Elixir projects, designed to make your codebase cleaner and more reusable. Includes utilities for working with changesets and common functional patterns.

## Features

- Changeset string trimming and blank-to-`nil` normalization.
- Validation that at least one of several changeset fields is present.
- Select-option generation with field or function selectors.
- Blank-value checks and helpers for conditionally building maps.
- Safe casting for Phoenix controller and LiveView params.
- Date parsing, number and money formatting, and common display helpers.

## Installation

Add `:jedi_helpers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jedi_helpers, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/jedi_helpers>.

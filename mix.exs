defmodule JediHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :jedi_helpers,
      version: "0.1.1",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Reusable helper functions for Elixir/Phoenix projects with a touch of the Force",
      package: [
        name: "jedi_helpers",
        maintainers: ["Obie"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/obieewan/jedi_helpers",
          "Changelog" => "https://github.com/obieewan/jedi_helpers/blob/main/CHANGELOG.md"
        }
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto, "~> 3.12.0"},
      # {:ex_cldr, "~> 2.42.0"},
      # {:ex_money, "~> 5.21.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:decimal, "~> 2.3.0"},
      {:number, "~> 1.0.5"},
      {:ex_money, "~> 5.21.0"}
    ]
  end
end

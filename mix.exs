defmodule JediHelpers.MixProject do
  use Mix.Project

  def project do
    [
      app: :jedi_helpers,
      version: "0.3.1",
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
        extras: ["README.md", "CHANGELOG.md"],
        skip_modules: [~r/^JediHelpers\.Cldr(\..+)?$/]
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
      {:ecto, "~> 3.14"},
      {:ex_doc, "~> 0.40.3", only: :dev, runtime: false},
      {:decimal, "~> 3.1"},
      {:ex_money, "~> 6.1"},
      {:ex_cldr, "~> 2.47"},
      {:ex_cldr_numbers, "~> 2.38"}
    ]
  end
end

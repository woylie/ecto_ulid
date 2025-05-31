defmodule Ecto.ULID.Mixfile do
  use Mix.Project

  @source_url "https://github.com/woylie/ecto_ulid"
  @version "1.0.2"

  def project do
    [
      app: :ecto_ulid_next,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.github": :test
      ],
      name: "Ecto.ULID",
      description: "An Ecto.Type implementation of ULID.",
      package: package(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, ".plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchee, "== 1.4.0", only: :dev},
      {:credo, "== 1.7.12", only: [:dev, :test], runtime: false},
      {:dialyxir, "== 1.4.5", only: [:dev], runtime: false},
      {:ecto, "~> 3.2"},
      {:ex_doc, "== 0.38.2", only: :dev, runtime: false},
      {:excoveralls, "== 0.18.5", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Mathias Polligkeit"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @source_url <> "/blob/main/CHANGELOG.md"
      },
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v" <> @version,
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end
end

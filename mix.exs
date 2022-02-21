defmodule Ecto.ULID.Mixfile do
  use Mix.Project

  @source_url "https://github.com/woylie/ecto_ulid"
  @version "0.3.0"

  def project do
    [
      app: :ecto_ulid_next,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Ecto.ULID",
      description: "An Ecto.Type implementation of ULID.",
      package: package(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_ref: "main"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Mathias Polligkeit"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @source_url <> "/blob/main/CHANGELOG.md"
      }
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:ecto, "~> 3.2"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end

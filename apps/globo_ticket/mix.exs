defmodule GloboTicket.MixProject do
  use Mix.Project

  def project do
    [
      app: :globo_ticket,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {GloboTicket.Application, []},
      extra_applications: [:logger, :runtime_tools, :ssl]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    phoenix_deps() ++ project_deps()
  end

  defp phoenix_deps do
    [
      {:phoenix_pubsub, "~> 2.0"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"}
    ]
  end

  defp project_deps do
    [
      {:emu, in_umbrella: true},
      {:faker, "~> 0.17"},
      {:typed_struct, "~> 0.3.0"},
      {:bus_driver, in_umbrella: true},
      {:utils, in_umbrella: true, only: :dev},
      {:vrt_clock, in_umbrella: true},
      {:vrt_identifier, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end

defmodule GloboTicket.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      aliases: aliases(),
      releases: releases(Mix.env()),
      preferred_cli_env: [
        check: :test
      ]
    ]
  end

  defp deps do
    []
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      list_unused_filters: true
    ]
  end

  defp aliases do
    setup = [
      "cmd --app globo_ticket mix setup",
      "cmd --app globo_ticket_demo mix setup",
      "cmd --app globo_ticket_web mix setup"
    ]

    [
      # run `mix setup` in all child apps
      setup: setup,
      check: ["compile --warnings-as-errors", "credo --strict", "dialyzer"]
    ]
  end

  defp releases(env) do
    apps = env |> release_apps() |> Enum.map(&{&1, :permanent})

    [
      globo_ticket: [
        include_executables_for: [:unix],
        include_erts: true,
        version: "0.0.0",
        applications: apps
      ]
    ]
  end

  defp release_apps(:prod), do: ~w(globo_ticket globo_ticket_web)a
  defp release_apps(_env), do: ~w(globo_ticket globo_ticket_web globo_ticket_demo)a
end

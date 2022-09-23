defmodule GloboTicketDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :globo_ticket_demo,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [setup: ["run -e 'GloboTicketDemo.Tasks.Setup.exec()'"]]
  end

  defp deps do
    [
      {:globo_ticket, in_umbrella: true}
    ]
  end
end

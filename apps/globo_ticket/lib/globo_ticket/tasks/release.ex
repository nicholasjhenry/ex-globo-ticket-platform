defmodule GloboTicket.Tasks.Release do
  @moduledoc false

  @app :globo_ticket

  require Logger

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed(filename \\ "seeds.exs") do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &eval_seed(&1, filename))
    end
  end

  defp eval_seed(_repo, filename) do
    seed_script = Application.app_dir(@app, ["priv", "repo", filename])

    Logger.info("==> Running seed script..")
    Code.eval_file(seed_script)
    Logger.info("==> completed.")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.ensure_all_started(:ssl)
    Application.load(@app)
  end
end

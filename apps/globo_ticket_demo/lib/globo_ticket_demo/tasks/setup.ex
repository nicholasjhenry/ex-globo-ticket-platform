defmodule GloboTicketDemo.Tasks.Setup do
  @moduledoc false

  @app :globo_ticket

  require Logger

  # mix run -e 'GloboTicketDemo.Task.Setup.exec()'
  # bin/setup_demo
  def exec do
    Application.ensure_all_started(:ssl)

    load_app()
    setup_demo()
  end

  defp load_app do
    Application.load(@app)
  end

  defp setup_demo do
    Logger.info("==> Inserting demo data...")
    # Add demo data
    :ok

    Logger.info("==> completed.")
  end
end

defmodule GloboTicket.Promotions.Acts.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Records

  def save_act(act) do
    record = %Records.Act{uuid: act.id}

    with {:ok, _} <- save_entity_record(Repo, record),
         record = get_act!(act.id),
         {:ok, _} <- save_snapshot(Repo, act, record, :description) do
      {:ok, act}
    end
  end

  defp get_act!(act_uuid) do
    Records.Act
    |> Acts.Query.snapshots_query()
    |> get_record!(Repo, act_uuid)
  end

  def delete_act(act_uuid) do
    Records.Act
    |> get_record!(Repo, act_uuid)
    |> soft_delete(Repo)
  end
end

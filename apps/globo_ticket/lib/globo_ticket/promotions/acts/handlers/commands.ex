defmodule GloboTicket.Promotions.Acts.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias Emu.Ticks

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Messages
  alias GloboTicket.Promotions.Acts.Projection
  alias GloboTicket.Promotions.Acts.Records

  def save_act(act) do
    record = %Records.Act{uuid: act.id}

    with {:ok, _} <- save_entity_record(Repo, record),
         record = get_act!(act.id),
         {:ok, _} <- save(Repo, act, record, :description) do
      {:ok, act}
    end
  end

  defp save(Repo, act, record, :description) do
    with {:ok, description_record} <- save_snapshot(Repo, act, record, :description) do
      applied_act = Projection.apply(act, description_record)

      if Emu.Ticks.compare(applied_act.last_updated_ticks, act.last_updated_ticks) == :gt do
        modified_date = Ticks.to_date_time(act.last_updated_ticks)

        message = %Messages.Events.ActDescriptionChanged{
          act_id: act.id,
          act_description_representation: %Messages.Representations.ActDescription{
            title: act.title,
            image_hash: act.image,
            modified_date: modified_date
          }
        }

        BusDriver.publish(:promotions, message)
      end

      {:ok, applied_act}
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

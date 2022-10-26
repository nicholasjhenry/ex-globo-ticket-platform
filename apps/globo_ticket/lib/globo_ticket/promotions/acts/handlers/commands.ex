defmodule GloboTicket.Promotions.Acts.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias Emu.Ticks

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Messages
  alias GloboTicket.Promotions.Acts.Records

  def save_act(act) do
    with {:ok, entity_record} <- save_entity(act) do
      save_description(act, entity_record)
    end
  end

  defp save_entity(act) do
    entity_record = %Records.Act{uuid: act.id}

    with {:ok, _entity_record} <- save_entity_record(Repo, entity_record) do
      {:ok, get_record!(act)}
    end
  end

  defp save_description(act, entity_record) do
    with {:ok, description_record} <- save_snapshot(Repo, act, entity_record, :description) do
      last_updated_ticks = Ticks.from_date_time(description_record.inserted_at)

      if Ticks.compare(last_updated_ticks, act.last_updated_ticks) == :gt do
        message = build_act_description_changed(act, description_record)
        BusDriver.publish(:promotions, message)
      end

      {:ok, description_record}
    end
  end

  defp build_act_description_changed(act, description_record) do
    act_description_representation = %Messages.Representations.ActDescription{
      title: description_record.title,
      image_hash: description_record.image,
      modified_date: description_record.inserted_at
    }

    %Messages.Events.ActDescriptionChanged{
      act_id: act.id,
      act_description_representation: act_description_representation
    }
  end

  defp get_record!(act) do
    Records.Act
    |> Acts.Query.snapshots_query()
    |> get_record!(Repo, act.id)
  end

  def delete_act(act_uuid) do
    Records.Act
    |> get_record!(Repo, act_uuid)
    |> soft_delete(Repo)
  end
end

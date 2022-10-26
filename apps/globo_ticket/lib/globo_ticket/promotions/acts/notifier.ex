defmodule GloboTicket.Promotions.Acts.Notifier do
  @moduledoc false

  alias Emu.Ticks

  alias GloboTicket.Promotions.Acts.Messages
  alias GloboTicket.Promotions.Acts.Records

  def notify(act, %Records.ActDescription{} = description_record) do
    last_updated_ticks = Ticks.from_date_time(description_record.inserted_at)

    if Ticks.compare(last_updated_ticks, act.last_updated_ticks) == :gt do
      message = build_act_description_changed(act, description_record)
      BusDriver.publish(:promotions, message)
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
end

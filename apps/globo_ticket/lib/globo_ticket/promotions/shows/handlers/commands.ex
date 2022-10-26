defmodule GloboTicket.Promotions.Shows.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Shows.Records

  def schedule_show(act_id, venue_id, start_at) do
    show_record = %Records.Show{act_uuid: act_id, venue_uuid: venue_id, start_at: start_at}

    with {:ok, show_record} <-
           Repo.insert(show_record,
             on_conflict: :nothing,
             conflict_target: [:act_uuid, :venue_uuid, :start_at]
           ) do
      _ = Shows.Notifier.notify(show_record)
      {:ok, show_record}
    end
  end

  def cancel_show(act_id, venue_id, start_at) do
    show_record = %Records.Show{act_uuid: act_id, venue_uuid: venue_id, start_at: start_at}

    {:ok, show_record} =
      Repo.insert(show_record,
        on_conflict: {:replace, [:id]},
        conflict_target: [:act_uuid, :venue_uuid, :start_at]
      )

    cancel_record = %Records.ShowCancelled{
      show_id: show_record.id,
      cancelled_at: DateTime.utc_now()
    }

    Repo.insert(cancel_record,
      on_conflict: :nothing,
      conflict_target: [:show_id]
    )
  end
end

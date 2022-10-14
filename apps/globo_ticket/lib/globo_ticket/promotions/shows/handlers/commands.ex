defmodule GloboTicket.Promotions.Shows.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Shows.Records

  def schedule_show(act_id, venue_id, start_at) do
    record = %Records.Show{act_uuid: act_id, venue_uuid: venue_id, start_at: start_at}

    Repo.insert(record)
  end
end

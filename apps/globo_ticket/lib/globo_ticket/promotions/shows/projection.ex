defmodule GloboTicket.Promotions.Shows.Projection do
  @moduledoc false

  use GloboTicket.Projection

  alias GloboTicket.Promotions.Shows.Records
  alias GloboTicket.Promotions.Venues

  def apply_all(entity, nil), do: entity

  def apply_all(entity, record) do
    apply(entity, record)
  end

  def apply(entity, %Records.Show{} = record) do
    %{
      entity
      | act_id: record.act_uuid,
        venue: Venues.Projection.apply_all(%Venues.Venue{}, record.venue),
        start_at: record.start_at
    }
  end
end

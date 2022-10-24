defmodule GloboTicket.Promotions.Acts.Projection do
  @moduledoc false

  use GloboTicket.Projection

  alias GloboTicket.Promotions.Acts.Records

  def apply_all(entity, nil), do: entity

  def apply_all(entity, record) do
    entity
    |> apply(record)
    |> apply(record.description)
  end

  def apply(entity, %Records.Act{} = record) do
    %{entity | id: record.uuid}
  end

  def apply(entity, %Records.ActDescription{} = record) do
    %{
      entity
      | title: record.title,
        image: record.image,
        last_updated_ticks: Ticks.from_date_time(record.inserted_at)
    }
  end
end

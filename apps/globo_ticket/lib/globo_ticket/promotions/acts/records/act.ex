defmodule GloboTicket.Promotions.Acts.Records.Act do
  @moduledoc false

  use GloboTicket.Record

  alias Emu.Ticks
  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Acts.Records

  schema "promotion_acts" do
    field :uuid, Ecto.UUID
    has_one :description, Records.ActDescription
    has_one :removed, Records.ActRemoved

    timestamps()
  end

  def to_entity(nil), do: nil

  def to_entity(record) do
    %Acts.Act{
      id: record.uuid,
      title: record.description.title,
      image: record.description.image,
      last_updated_ticks: Ticks.from_date_time(record.description.inserted_at)
    }
  end
end

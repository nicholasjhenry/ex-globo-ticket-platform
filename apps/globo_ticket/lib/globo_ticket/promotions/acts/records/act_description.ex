defmodule GloboTicket.Promotions.Acts.Records.ActDescription do
  @moduledoc false

  use GloboTicket.Record

  schema "promotion_act_descriptions" do
    field :title, :string
    field :image, :string
    field :act_id, :id

    timestamps(updated_at: false)
  end

  def equal?(nil, _next_snapshot) do
    false
  end

  def equal?(last_snapshot, next_snapshot) do
    last_snapshot.title == next_snapshot.title &&
      last_snapshot.image == next_snapshot.image
  end

  def from_entity(entity, record) do
    %__MODULE__{
      act_id: record.id,
      title: entity.title,
      image: entity.image
    }
  end
end

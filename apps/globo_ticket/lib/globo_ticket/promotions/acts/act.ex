defmodule GloboTicket.Promotions.Acts.Act do
  @moduledoc false

  use GloboTicket.Entity

  embedded_schema do
    field :title, :string
    field :last_updated_ticks, :integer
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:id, :title])
    |> validate_required([:id, :title])
  end

  def from_params(struct, params) do
    struct
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:converted)
  end
end

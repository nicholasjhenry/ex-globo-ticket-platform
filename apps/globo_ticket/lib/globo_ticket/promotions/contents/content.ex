defmodule GloboTicket.Promotions.Contents.Content do
  @moduledoc false

  use GloboTicket.Entity

  embedded_schema do
    field :body, :string
    field :name, :string
    field :type, :string
    field :hash, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:id, :body, :name, :type])
    |> validate_required([:id, :body, :name, :type])
  end

  def from_params(struct, params) do
    struct
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:converted)
  end
end

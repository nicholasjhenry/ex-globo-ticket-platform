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

  def parse(struct, params) do
    struct
    |> changeset(params)
    |> apply_action(:parsed)
  end
end

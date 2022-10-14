defmodule GloboTicket.Repo.Migrations.CreatePromotionActs do
  use Ecto.Migration

  def change do
    create table(:promotion_acts) do
      add :uuid, :uuid

      timestamps()
    end

    create unique_index(:promotion_acts, [:uuid])
  end
end

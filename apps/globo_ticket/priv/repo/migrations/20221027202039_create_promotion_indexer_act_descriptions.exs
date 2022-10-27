defmodule GloboTicket.Repo.Migrations.CreatePromotionIndexerActDescriptions do
  use Ecto.Migration

  def change do
    create table(:promotion_indexer_act_descriptions) do
      add :act_uuid, :uuid
      add :title, :string, null: false
      add :image_hash, :string, null: true
      add :last_updated_at, :utc_datetime_usec, null: false

      timestamps()
    end

    create unique_index(:promotion_indexer_act_descriptions, [:act_uuid])
  end
end

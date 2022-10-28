defmodule GloboTicket.Repo.Migrations.CreatePromotionIndexerVenueDescriptions do
  use Ecto.Migration

  def change do
    create table(:promotion_indexer_venue_descriptions) do
      add :venue_uuid, :uuid
      add :name, :string, null: false
      add :city, :string, null: false
      add :last_updated_at, :utc_datetime_usec, null: false

      timestamps()
    end

    create unique_index(:promotion_indexer_venue_descriptions, [:venue_uuid])
  end
end

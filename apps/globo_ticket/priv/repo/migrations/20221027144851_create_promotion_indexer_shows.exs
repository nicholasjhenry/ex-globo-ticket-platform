defmodule GloboTicket.Repo.Migrations.CreatePromotionIndexerShows do
  use Ecto.Migration

  def change do
    create table(:promotion_indexer_shows) do
      add :act_uuid, :uuid, null: false
      add :venue_uuid, :uuid, null: false
      add :start_at, :utc_datetime_usec, null: false
      add :hash, :string, null: false
      add :act_title, :string, null: false
      add :act_image_hash, :string, null: false
      add :venue_name, :string, null: false
      add :venue_latitude, :float, null: false
      add :venue_longitude, :float, null: false

      timestamps()
    end

    create unique_index(:promotion_indexer_shows, :hash)
    create index(:promotion_indexer_shows, :act_uuid)
    create index(:promotion_indexer_shows, :venue_uuid)
    create index(:promotion_indexer_shows, :act_title)
    create index(:promotion_indexer_shows, :venue_name)
    create index(:promotion_indexer_shows, [:venue_latitude, :venue_longitude])
  end
end

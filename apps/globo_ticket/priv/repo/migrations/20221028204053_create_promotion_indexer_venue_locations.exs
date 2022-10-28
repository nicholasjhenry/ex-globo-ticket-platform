defmodule GloboTicket.Repo.Migrations.CreatePromotionIndexerVenueLocations do
  use Ecto.Migration

  def change do
    create table(:promotion_indexer_venue_locations) do
      add :venue_uuid, :uuid
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :last_updated_at, :utc_datetime_usec, null: false

      timestamps()
    end

    create unique_index(:promotion_indexer_venue_locations, [:venue_uuid])
  end
end

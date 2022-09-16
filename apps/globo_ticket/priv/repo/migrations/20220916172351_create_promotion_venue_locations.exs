defmodule GloboTicket.Repo.Migrations.CreatePromotionVenueLocations do
  use Ecto.Migration

  def change do
    create table(:promotion_venue_locations) do
      add :latitude, :float, null: false
      add :longitude, :float, null: false
      add :venue_id, references(:promotion_venues, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create index(:promotion_venue_locations, [:venue_id])
  end
end

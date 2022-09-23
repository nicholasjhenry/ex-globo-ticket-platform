defmodule GloboTicket.Repo.Migrations.CreatePromotionVenueTimeZones do
  use Ecto.Migration

  def change do
    create table(:promotion_venue_time_zones) do
      add :time_zone, :string, null: false
      add :venue_id, references(:promotion_venues, on_delete: :delete_all)

      timestamps(updated_at: false)
    end

    create index(:promotion_venue_time_zones, [:venue_id])
  end
end

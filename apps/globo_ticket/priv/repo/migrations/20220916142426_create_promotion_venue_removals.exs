defmodule GloboTicket.Repo.Migrations.CreatePromotionVenueRemovals do
  use Ecto.Migration

  def change do
    create table(:promotion_venue_removals) do
      add :removed_at, :utc_datetime_usec
      add :venue_id, references(:promotion_venues, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create index(:promotion_venue_removals, [:venue_id])
  end
end

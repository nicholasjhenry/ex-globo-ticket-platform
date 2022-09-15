defmodule GloboTicket.Repo.Migrations.CreatePromotionVenueDescriptions do
  use Ecto.Migration

  def change do
    create table(:promotion_venue_descriptions) do
      add :name, :string, null: false
      add :city, :string, null: false
      add :venue_id, references(:promotion_venues, on_delete: :delete_all), null: false

      timestamps(updated_at: false)
    end

    create index(:promotion_venue_descriptions, [:venue_id])
  end
end

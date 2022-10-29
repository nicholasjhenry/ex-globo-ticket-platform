defmodule GloboTicket.Repo.Migrations.CreatePromotionShows do
  use Ecto.Migration

  def change do
    create table(:promotion_shows) do
      add :act_uuid, :uuid, null: false
      add :venue_uuid, :uuid, null: false
      add :start_at, :utc_datetime_usec, null: false
      add :hash, :string, null: false

      timestamps(updated_at: false)
    end

    create unique_index(:promotion_shows, [:hash])
    create index(:promotion_shows, :act_uuid)
  end
end

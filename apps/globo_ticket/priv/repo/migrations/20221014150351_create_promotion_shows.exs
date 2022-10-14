defmodule GloboTicket.Repo.Migrations.CreatePromotionShows do
  use Ecto.Migration

  def change do
    create table(:promotion_shows) do
      add :act_uuid, :uuid
      add :venue_uuid, :uuid
      add :start_at, :utc_datetime_usec

      timestamps(updated_at: false)
    end

    create unique_index(:promotion_shows, [:act_uuid, :venue_uuid, :start_at])
  end
end

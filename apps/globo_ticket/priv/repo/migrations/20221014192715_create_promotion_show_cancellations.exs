defmodule GloboTicket.Repo.Migrations.CreatePromotionShowCancellations do
  use Ecto.Migration

  def change do
    create table(:promotion_show_cancellations) do
      add :cancelled_at, :utc_datetime_usec
      add :show_id, references(:promotion_shows, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create unique_index(:promotion_show_cancellations, [:show_id])
  end
end

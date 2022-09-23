defmodule GloboTicket.Repo.Migrations.CreatePromotionActRemovals do
  use Ecto.Migration

  def change do
    create table(:promotion_act_removals) do
      add :removed_at, :utc_datetime_usec
      add :act_id, references(:promotion_acts, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create index(:promotion_act_removals, [:act_id])
  end
end

defmodule GloboTicket.Repo.Migrations.CreatePromotionActDescriptions do
  use Ecto.Migration

  def change do
    create table(:promotion_act_descriptions) do
      add :title, :string, null: false
      add :image, :string, null: true
      add :act_id, references(:promotion_acts, on_delete: :delete_all), null: false

      timestamps(updated_at: false)
    end

    create index(:promotion_act_descriptions, [:act_id])
  end
end

defmodule GloboTicket.Repo.Migrations.CreatePromotionShowsIndex do
  use Ecto.Migration

  def change do
    create table(:promotion_show_index) do
      add :act_uuid, :uuid, null: false
      add :venue_uuid, :uuid, null: false
      add :start_at, :utc_datetime_usec, null: false
      add :act_title, :string, null: false
      add :act_image_hash, :string, null: false
      add :venue_name, :string, null: false
      add :venue_latitude, :float, null: false
      add :venue_longitude, :float, null: false

      timestamps()
    end

    create unique_index(:promotion_show_index, [:act_uuid, :venue_uuid, :start_at])
    create index(:promotion_show_index, :act_title)
    create index(:promotion_show_index, :venue_name)
    create index(:promotion_show_index, [:venue_latitude, :venue_longitude])
  end
end

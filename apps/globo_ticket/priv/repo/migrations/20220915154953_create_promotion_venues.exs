defmodule GloboTicket.Repo.Migrations.CreatePromotionVenues do
  use Ecto.Migration

  def change do
    create table(:promotion_venues) do
      add :uuid, :uuid

      timestamps()
    end

    create unique_index(:promotion_venues, [:uuid])
  end
end

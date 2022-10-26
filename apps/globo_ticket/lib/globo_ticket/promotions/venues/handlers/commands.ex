defmodule GloboTicket.Promotions.Venues.Handlers.Commands do
  @moduledoc false

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def save_venue(venue) do
    with {:ok, record} <- save_entity(venue),
         {:ok, _} <- save_description(venue, record),
         {:ok, _} <- save_location(venue, record),
         {:ok, _} <- save_time_zone(venue, record) do
      {:ok, venue}
    end
  end

  def save_entity(venue) do
    record = %Records.Venue{uuid: venue.id}

    with {:ok, _} <- save_entity_record(Repo, record) do
      {:ok, get_record!(venue.id)}
    end
  end

  defp save_description(venue, entity_record) do
    with {:ok, description_record} <- save_snapshot(Repo, venue, entity_record, :description) do
      _ = Venues.Notifier.notify(venue, description_record)

      {:ok, description_record}
    end
  end

  defp save_location(venue, record) do
    with {:ok, location_record} <-
           save_snapshot(Repo, venue, record, :location, :location_last_updated_ticks) do
      _ = Venues.Notifier.notify(venue, location_record)
      {:ok, location_record}
    end
  end

  defp save_time_zone(venue, record) do
    with {:ok, time_zone_record} <-
           save_snapshot(Repo, venue, record, :time_zone, :time_zone_last_updated_ticks) do
      _ = Venues.Notifier.notify(venue, time_zone_record)

      {:ok, time_zone_record}
    end
  end

  defp get_record!(venue_uuid) do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> get_record!(Repo, venue_uuid)
  end

  def delete_venue(venue_uuid) do
    Records.Venue
    |> get_record!(Repo, venue_uuid)
    |> soft_delete(Repo)
  end
end

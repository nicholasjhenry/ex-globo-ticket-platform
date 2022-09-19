defmodule GloboTicket.Promotions.Venues.Handlers.Commands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues
  alias GloboTicket.Promotions.Venues.Records

  def save_venue(venue) do
    record = %Records.Venue{uuid: venue.id}

    with {:ok, _} <- save_entity_record(record),
         record = get_venue!(venue.id),
         {:ok, _} <- save_snapshot(venue, record, :description),
         {:ok, _} <- save_snapshot(venue, record, :location, :location_last_updated_ticks),
         {:ok, _} <- save_snapshot(venue, record, :time_zone, :time_zone_last_updated_ticks) do
      {:ok, venue}
    end
  end

  defp get_venue!(venue_uuid) do
    Records.Venue
    |> Venues.Query.snapshots_query()
    |> Repo.get_by(uuid: venue_uuid)
  end

  def delete_venue(venue_uuid) do
    Records.Venue
    |> Repo.get_by!(uuid: venue_uuid)
    |> soft_delete()
  end
end

defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias GloboTicket.Promotions.Venues

  use GloboTicket.QueryHandler

  def get_venue(uuid) do
    Venues.Venue
    |> present
    |> Repo.get_by(uuid: uuid)
    |> preload_venue()
    |> to_venue_info()
  end

  def list_venues do
    Venues.Venue
    |> present
    |> Repo.all()
    |> preload_venue()
    |> Enum.map(&to_venue_info/1)
  end

  defp present(query) do
    from record in query, left_join: removed in assoc(record, :removed), where: is_nil(removed.id)
  end

  defp preload_venue(venue_or_venues) do
    Repo.preload(venue_or_venues, descriptions: most_recent(Venues.VenueDescription))
  end

  defp to_venue_info(nil), do: nil

  defp to_venue_info(venue_record) do
    [description_record] = venue_record.descriptions

    %Venues.VenueInfo{
      uuid: venue_record.uuid,
      name: description_record.name,
      city: description_record.city,
      last_updated_ticks: to_ticks(description_record.inserted_at)
    }
  end

  defp most_recent(query) do
    from query, order_by: [desc: :inserted_at], limit: 1
  end

  defp to_ticks(date_time) do
    if date_time do
      DateTime.to_gregorian_seconds(date_time)
    else
      {0, 0}
    end
  end
end

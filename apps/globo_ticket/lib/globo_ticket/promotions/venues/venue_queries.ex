defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias GloboTicket.Promotions.Venues

  use GloboTicket.QueryHandler

  def get_venue(uuid) do
    Venues.Venue
    |> Repo.get_by(uuid: uuid)
    |> preload_venue()
    |> to_venue_info()
  end

  def list_venues do
    Venues.Venue
    |> Repo.all()
    |> preload_venue()
    |> Enum.map(&to_venue_info/1)
  end

  defp preload_venue(venue_or_venues) do
    Repo.preload(venue_or_venues, descriptions: most_recent(Venues.VenueDescription))
  end

  defp to_venue_info(venue_record) do
    [description_record] = venue_record.descriptions

    %Venues.VenueInfo{
      uuid: venue_record.uuid,
      name: description_record.name,
      city: description_record.city
    }
  end

  defp most_recent(query) do
    from query, order_by: [desc: :inserted_at], limit: 1
  end
end

defmodule GloboTicket.Promotions.Venues.VenueQueries do
  @moduledoc """
  Handles queries for venues.
  """

  alias GloboTicket.Promotions.Venues

  use GloboTicket.QueryHandler

  def list_venues do
    Venues.Venue
    |> Repo.all()
    |> Enum.map(&build_venue_info/1)
  end

  def build_venue_info(record) do
    %Venues.VenueInfo{uuid: record.uuid}
  end
end

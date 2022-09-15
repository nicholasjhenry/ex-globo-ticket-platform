defmodule GloboTicket.Promotions.Venues.VenueCommands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues

  def save_venue(uuid, venue_info) do
    with {:ok, venue} <-
           Repo.insert(%Venues.Venue{uuid: uuid},
             on_conflict: {:replace, [:uuid]},
             conflict_target: [:uuid]
           ) do
      Repo.insert(%Venues.VenueDescription{
        venue_id: venue.id,
        name: venue_info.name,
        city: venue_info.city
      })
    end
  end
end

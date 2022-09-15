defmodule GloboTicket.Promotions.Venues.VenueCommands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias GloboTicket.Promotions.Venues

  def save_venue(uuid, _venue_info) do
    Repo.insert(%Venues.Venue{uuid: uuid})
  end
end

defmodule GloboTicket.Promotions.Shows.Handlers.Queries do
  @moduledoc false

  use GloboTicket.QueryHandler

  alias GloboTicket.Promotions.Shows.Records
  alias GloboTicket.Promotions.Venues

  def list_shows(act_id) do
    show_query = from Records.Show, where: [act_uuid: ^act_id]

    venue_query =
      Venues.Records.Venue
      |> Venues.Query.snapshots_query()

    show_query
    |> Repo.all()
    |> Repo.preload(venue: venue_query)
    |> Enum.map(&Records.Show.to_entity/1)
  end
end

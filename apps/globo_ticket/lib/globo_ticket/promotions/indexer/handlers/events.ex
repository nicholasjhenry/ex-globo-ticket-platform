defmodule GloboTicket.Promotions.Indexer.Handlers.Events do
  @moduledoc false

  use GloboTicket.EventHandler

  alias GloboTicket.Promotions.Shows

  alias GloboTicket.Promotions.Indexer.Records

  def handle(%Shows.Messages.Events.ShowAdded{} = event) do
    %Records.Show{
      act_uuid: event.act_representation.act_id,
      venue_uuid: event.venue_representation.venue_id,
      start_at: event.show_representation.start_at,
      act_title: event.act_representation.act_description_representation.title,
      act_image_hash: event.act_representation.act_description_representation.image_hash,
      venue_name: event.venue_representation.venue_description_representation.name,
      venue_latitude: event.venue_representation.venue_location_representation.latitude,
      venue_longitude: event.venue_representation.venue_location_representation.longitude
    }
    |> Repo.insert()
  end
end

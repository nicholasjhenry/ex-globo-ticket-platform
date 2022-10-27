defmodule GloboTicket.Promotions.Indexer.Handlers.Events do
  @moduledoc false

  use GloboTicket.EventHandler

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows

  alias GloboTicket.Promotions.Indexer.Records

  def handle(%Shows.Messages.Events.ShowAdded{} = event) do
    act_representation = event.act_representation

    act_description_record =
      maybe_insert_act_description(
        act_representation.act_id,
        act_representation.act_description_representation
      )

    venue_description_representation = event.venue_representation.venue_description_representation
    venue_location_representation = event.venue_representation.venue_location_representation

    %Records.Show{
      act_uuid: event.act_representation.act_id,
      venue_uuid: event.venue_representation.venue_id,
      start_at: event.show_representation.start_at,
      act_title: act_description_record.title,
      act_image_hash: act_description_record.image_hash,
      venue_name: venue_description_representation.name,
      venue_latitude: venue_location_representation.latitude,
      venue_longitude: venue_location_representation.longitude
    }
    |> Repo.insert()
  end

  def handle(%Acts.Messages.Events.ActDescriptionChanged{} = event) do
    act_description_record =
      maybe_insert_act_description(event.act_id, event.act_description_representation)

    query = from(show in Records.Show, where: show.act_uuid == ^act_description_record.act_uuid)
    result = Repo.update_all(query, set: [act_title: act_description_record.title])

    {:ok, result}
  end

  defp maybe_insert_act_description(act_uuid, act_description_representation) do
    record = Repo.get_by(Records.ActDescription, act_uuid: act_uuid)

    cond do
      is_nil(record) ->
        insert_act_description(act_uuid, act_description_representation)

      record &&
          DateTime.compare(act_description_representation.modified_date, record.last_updated_at) ==
            :gt ->
        insert_act_description(act_uuid, act_description_representation)

      true ->
        record
    end
  end

  defp insert_act_description(act_uuid, act_description_representation) do
    %Records.ActDescription{
      act_uuid: act_uuid,
      title: act_description_representation.title,
      image_hash: act_description_representation.image_hash,
      last_updated_at: act_description_representation.modified_date
    }
    |> Repo.insert!(
      on_conflict: {:replace, [:title, :last_updated_at]},
      conflict_target: [:act_uuid]
    )
  end
end

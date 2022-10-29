defmodule GloboTicket.Promotions.Indexer.Handlers.Events do
  @moduledoc false

  use GloboTicket.EventHandler

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  alias GloboTicket.Promotions.Indexer.Records

  def handle(%Shows.Messages.Events.ShowAdded{} = event) do
    act_representation = event.act_representation
    venue_representation = event.venue_representation

    act_description_record =
      maybe_upsert_act_description(
        act_representation.act_id,
        act_representation.act_description_representation
      )

    venue_description_record =
      maybe_upsert_venue_description(
        venue_representation.venue_id,
        venue_representation.venue_description_representation
      )

    venue_location_record =
      maybe_upsert_venue_location(
        venue_representation.venue_id,
        venue_representation.venue_location_representation
      )

    insert_show(event, act_description_record, venue_description_record, venue_location_record)
  end

  def handle(%Acts.Messages.Events.ActDescriptionChanged{} = event) do
    act_description_record =
      maybe_upsert_act_description(event.act_id, event.act_description_representation)

    query = from(show in Records.Show, where: show.act_uuid == ^act_description_record.act_uuid)
    result = Repo.update_all(query, set: [act_title: act_description_record.title])

    {:ok, result}
  end

  def handle(%Venues.Messages.Events.VenueDescriptionChanged{} = event) do
    venue_description_record =
      maybe_upsert_venue_description(event.venue_id, event.venue_description_representation)

    query =
      from(show in Records.Show, where: show.venue_uuid == ^venue_description_record.venue_uuid)

    result = Repo.update_all(query, set: [venue_name: venue_description_record.name])

    {:ok, result}
  end

  def handle(%Venues.Messages.Events.VenueLocationChanged{} = event) do
    venue_location_record =
      maybe_upsert_venue_location(event.venue_id, event.venue_location_representation)

    query =
      from(show in Records.Show, where: show.venue_uuid == ^venue_location_record.venue_uuid)

    result =
      Repo.update_all(query,
        set: [
          venue_latitude: venue_location_record.latitude,
          venue_longitude: venue_location_record.longitude
        ]
      )

    {:ok, result}
  end

  defp insert_show(event, act_description_record, venue_description_record, venue_location_record) do
    %Records.Show{
      act_uuid: event.act_representation.act_id,
      venue_uuid: event.venue_representation.venue_id,
      start_at: event.show_representation.start_at,
      act_title: act_description_record.title,
      act_image_hash: act_description_record.image_hash,
      venue_name: venue_description_record.name,
      venue_latitude: venue_location_record.latitude,
      venue_longitude: venue_location_record.longitude
    }
    |> Records.Show.hash()
    |> Repo.insert(on_conflict: :nothing, conflict_target: [:hash])
  end

  defp maybe_upsert_act_description(act_uuid, act_description_representation) do
    record = Repo.get_by(Records.ActDescription, act_uuid: act_uuid)

    cond do
      is_nil(record) ->
        upsert_act_description(act_uuid, act_description_representation)

      record &&
          DateTime.compare(act_description_representation.modified_date, record.last_updated_at) ==
            :gt ->
        upsert_act_description(act_uuid, act_description_representation)

      true ->
        record
    end
  end

  defp upsert_act_description(act_uuid, act_description_representation) do
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

  defp maybe_upsert_venue_description(venue_uuid, venue_description_representation) do
    record = Repo.get_by(Records.VenueDescription, venue_uuid: venue_uuid)

    cond do
      is_nil(record) ->
        upsert_venue_description(venue_uuid, venue_description_representation)

      record &&
          DateTime.compare(venue_description_representation.modified_date, record.last_updated_at) ==
            :gt ->
        upsert_venue_description(venue_uuid, venue_description_representation)

      true ->
        record
    end
  end

  defp upsert_venue_description(venue_uuid, venue_description_representation) do
    %Records.VenueDescription{
      venue_uuid: venue_uuid,
      name: venue_description_representation.name,
      city: venue_description_representation.city,
      last_updated_at: venue_description_representation.modified_date
    }
    |> Repo.insert!(
      on_conflict: {:replace, [:name, :city, :last_updated_at]},
      conflict_target: [:venue_uuid]
    )
  end

  defp maybe_upsert_venue_location(venue_uuid, venue_location_representation) do
    record = Repo.get_by(Records.VenueLocation, venue_uuid: venue_uuid)

    cond do
      is_nil(record) ->
        upsert_venue_location(venue_uuid, venue_location_representation)

      record &&
          DateTime.compare(venue_location_representation.modified_date, record.last_updated_at) ==
            :gt ->
        upsert_venue_location(venue_uuid, venue_location_representation)

      true ->
        record
    end
  end

  defp upsert_venue_location(venue_uuid, venue_location_representation) do
    %Records.VenueLocation{
      venue_uuid: venue_uuid,
      latitude: venue_location_representation.latitude,
      longitude: venue_location_representation.longitude,
      last_updated_at: venue_location_representation.modified_date
    }
    |> Repo.insert!(
      on_conflict: {:replace, [:latitude, :longitude, :last_updated_at]},
      conflict_target: [:venue_uuid]
    )
  end
end

defmodule GloboTicket.Promotions.Venues.VenueCommands do
  @moduledoc """
  Handles commands for venues.
  """

  use GloboTicket.CommandHandler

  alias Emu.Snapshot
  alias Emu.Ticks
  alias GloboTicket.Promotions.Venues

  def save_venue(uuid, venue_info) do
    with {:ok, venue} <-
           Repo.insert(%Venues.Venue{uuid: uuid},
             on_conflict: {:replace, [:uuid]},
             conflict_target: [:uuid]
           ) do
      venue = Repo.preload(venue, description: Snapshot.last_snapshot(Venues.VenueDescription))

      if description_equal?(venue_info, venue.description) do
        {:ok, venue}
      else
        updated_ticks =
          if venue.description do
            Ticks.from_date_time(venue.description.inserted_at)
          end

        if venue_info.last_updated_ticks != {0, 0} &&
             updated_ticks != venue_info.last_updated_ticks do
          raise Ecto.StaleEntryError, action: :insert, changeset: %{data: venue.description}
        end

        with {:ok, description} <-
               Repo.insert(%Venues.VenueDescription{
                 venue_id: venue.id,
                 name: venue_info.name,
                 city: venue_info.city
               }) do
          venue = %{venue | description: description}
          {:ok, venue}
        end
      end
    end
  end

  def delete_venue(venue_uuid) do
    venue = Repo.get_by(Venues.Venue, uuid: venue_uuid)

    venue
    |> Ecto.build_assoc(:removed, removed_at: DateTime.utc_now())
    |> Repo.insert()
  end

  defp description_equal?(venue_info, %Venues.VenueDescription{} = description) do
    venue_info.name == description.name &&
      venue_info.city == description.city
  end

  defp description_equal?(_venue_info, nil) do
    false
  end
end

defmodule GloboTicket.Promotions.Shows.Notifier do
  @moduledoc false

  alias Emu.Ticks

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Venues

  alias GloboTicket.Promotions.Shows.Messages
  alias GloboTicket.Promotions.Shows.Records

  def notify(%Records.Show{} = show_record) do
    act = Acts.Store.get_act!(show_record.act_uuid)

    act_description_representation = %Acts.Messages.Representations.ActDescription{
      title: act.title,
      image_hash: act.image,
      modified_date: Ticks.to_date_time(act.last_updated_ticks)
    }

    act_representation = %Acts.Messages.Representations.Act{
      act_id: act.id,
      act_description_representation: act_description_representation
    }

    venue = Venues.Store.get_venue!(show_record.venue_uuid)

    venue_description_representation = %Venues.Messages.Representations.VenueDescription{
      city: venue.city,
      name: venue.name,
      modified_date: Ticks.to_date_time(venue.last_updated_ticks)
    }

    venue_location_representation = %Venues.Messages.Representations.VenueLocation{
      latitude: venue.latitude,
      longitude: venue.longitude,
      modified_date: Ticks.to_date_time(venue.location_last_updated_ticks)
    }

    venue_time_zone_representation = %Venues.Messages.Representations.VenueTimeZone{
      time_zone: venue.time_zone,
      modified_date: Ticks.to_date_time(venue.time_zone_last_updated_ticks)
    }

    venue_representation = %Venues.Messages.Representations.Venue{
      venue_id: venue.id,
      venue_description_representation: venue_description_representation,
      venue_location_representation: venue_location_representation,
      venue_time_zone_representation: venue_time_zone_representation
    }

    show_represenation = %Messages.Representations.Show{
      start_at: show_record.start_at
    }

    message = %Messages.Events.ShowAdded{
      act_representation: act_representation,
      venue_representation: venue_representation,
      show_representation: show_represenation
    }

    BusDriver.publish(:promotions, message)
  end
end

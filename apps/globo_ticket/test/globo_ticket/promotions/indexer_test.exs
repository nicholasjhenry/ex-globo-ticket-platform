defmodule GloboTicket.Promotions.IndexerTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows
  alias GloboTicket.Promotions.Venues

  alias GloboTicket.Promotions.Indexer.Handlers
  alias GloboTicket.Promotions.Indexer.Records

  test "when show is added then show is indexed" do
    show_added =
      given_show_added(%{
        act: %{title: "Expected act title"},
        venue: %{name: "Expected venue name"}
      })

    {:ok, _record} = Handlers.Events.handle(show_added)

    show = Repo.one(Records.Show)

    assert show
    assert show.act_title == "Expected act title"
    assert show.venue_name == "Expected venue name"
  end

  test "when show is added twice then one show is indexed" do
    show_added = given_show_added()

    {:ok, _record} = Handlers.Events.handle(show_added)
    {:ok, _record} = Handlers.Events.handle(show_added)

    shows = Repo.all(Records.Show)

    assert Enum.count(shows) == 1
  end

  test "when act description changed after show is added then show is updated" do
    show_added =
      given_show_added(%{
        act: %{title: "Original Title", description_age: 1}
      })

    act_description_changed =
      given_act_description_changed(%{
        act: %{act_id: show_added.act_representation.act_id, title: "Modified Title"}
      })

    {:ok, _record} = Handlers.Events.handle(show_added)
    {:ok, _record} = Handlers.Events.handle(act_description_changed)

    show = Repo.one(Records.Show)

    assert show
    assert show.act_title == "Modified Title"
  end

  test "when act description changed arrives before show is added then show uses the latest description" do
    show_added =
      given_show_added(%{
        act: %{title: "Original Title", description_age: 1}
      })

    act_description_changed =
      given_act_description_changed(%{
        act: %{act_id: show_added.act_representation.act_id, title: "Modified Title"}
      })

    {:ok, _record} = Handlers.Events.handle(act_description_changed)
    {:ok, _record} = Handlers.Events.handle(show_added)

    show = Repo.one(Records.Show)

    assert show
    assert show.act_title == "Modified Title"
  end

  test "when venue description is changed after show is added then show is updated" do
    show_added =
      given_show_added(%{
        venue: %{name: "Original Name", description_age: 1}
      })

    venue_description_changed =
      given_venue_description_changed(%{
        venue: %{venue_id: show_added.venue_representation.venue_id, name: "Modified Name"}
      })

    {:ok, _record} = Handlers.Events.handle(show_added)
    {:ok, _record} = Handlers.Events.handle(venue_description_changed)

    show = Repo.one(Records.Show)

    assert show
    assert show.venue_name == "Modified Name"
  end

  test "when venue description change arrives before show added then show uses latest description" do
    show_added =
      given_show_added(%{
        venue: %{name: "Original Name", description_age: 1}
      })

    venue_description_changed =
      given_venue_description_changed(%{
        venue: %{venue_id: show_added.venue_representation.venue_id, name: "Modified Name"}
      })

    {:ok, _record} = Handlers.Events.handle(venue_description_changed)
    {:ok, _record} = Handlers.Events.handle(show_added)

    show = Repo.one(Records.Show)

    assert show
    assert show.venue_name == "Modified Name"
  end

  test "when venue location is changed after show is added then show is updated" do
    show_added =
      given_show_added(%{
        venue: %{latitude: 0.1, longitude: 0.2, location_age: 1}
      })

    venue_location_changed =
      given_venue_location_changed(%{
        venue: %{
          venue_id: show_added.venue_representation.venue_id,
          latitude: 0.3,
          longitude: 0.4
        }
      })

    {:ok, _record} = Handlers.Events.handle(show_added)
    {:ok, _record} = Handlers.Events.handle(venue_location_changed)

    show = Repo.one(Records.Show)

    assert show
    assert show.venue_latitude == 0.3
    assert show.venue_longitude == 0.4
  end

  test "when venue location change arrives before show added then show uses latest location" do
    show_added =
      given_show_added(%{
        venue: %{latitude: 0.1, longitude: 0.2, location_age: 1}
      })

    venue_location_changed =
      given_venue_location_changed(%{
        venue: %{
          venue_id: show_added.venue_representation.venue_id,
          latitude: 0.3,
          longitude: 0.4
        }
      })

    {:ok, _record} = Handlers.Events.handle(venue_location_changed)
    {:ok, _record} = Handlers.Events.handle(show_added)

    show = Repo.one(Records.Show)

    assert show
    assert show.venue_latitude == 0.3
    assert show.venue_longitude == 0.4
  end

  def given_show_added(attrs \\ %{}) do
    act_attrs = Map.get(attrs, :act, %{})
    act_description_representation = given_act_description(act_attrs)

    act_attrs = Map.take(act_attrs, [:act_id])

    act_representation =
      act_attrs
      |> Map.merge(%{act_description_representation: act_description_representation})
      |> Acts.Controls.Messages.Representations.Act.generate()

    venue_attrs = Map.get(attrs, :venue, %{})
    venue_description_representation = given_venue_description(venue_attrs)
    venue_location_representation = given_venue_location(venue_attrs)

    venue_representation =
      Venues.Controls.Messages.Representations.Venue.generate(
        venue_description_representation: venue_description_representation,
        venue_location_representation: venue_location_representation
      )

    Shows.Controls.Messages.Events.ShowAdded.generate(
      act_representation: act_representation,
      venue_representation: venue_representation
    )
  end

  def given_act_description_changed(attrs) do
    attrs = Map.get(attrs, :act, %{})

    act_description_representation = given_act_description(attrs)

    attrs = Map.take(attrs, [:act_id])

    attrs
    |> Map.merge(%{act_description_representation: act_description_representation})
    |> Acts.Controls.Messages.Events.ActDescriptionChanged.generate()
  end

  def given_actiption(attrs) do
    attrs = Map.take(attrs, [:title])
    Acts.Controls.Messages.Representations.ActDescription.generate(attrs)
  end

  def given_act_description(attrs) do
    description_attrs = Map.take(attrs, [:title])
    days = Map.get(attrs, :description_age, 0)
    modified_date = Clock.Controls.DateTime.age({days, :days})

    description_attrs
    |> Map.put(:modified_date, modified_date)
    |> Acts.Controls.Messages.Representations.ActDescription.generate()
  end

  def given_venue_description(attrs) do
    description_attrs = Map.take(attrs, [:name])
    days = Map.get(attrs, :description_age, 0)
    modified_date = Clock.Controls.DateTime.age({days, :days})

    description_attrs
    |> Map.put(:modified_date, modified_date)
    |> Venues.Controls.Messages.Representations.VenueDescription.generate()
  end

  def given_venue_description_changed(attrs) do
    attrs = Map.get(attrs, :venue, %{})
    venue_description_representation = given_venue_description(attrs)

    attrs = Map.take(attrs, [:venue_id])

    attrs
    |> Map.merge(%{venue_description_representation: venue_description_representation})
    |> Venues.Controls.Messages.Events.VenueDescriptionChanged.generate()
  end

  def given_venue_location(attrs) do
    location_attrs = Map.take(attrs, [:latitude, :longitude])
    days = Map.get(attrs, :location_age, 0)
    modified_date = Clock.Controls.DateTime.age({days, :days})

    location_attrs
    |> Map.put(:modified_date, modified_date)
    |> Venues.Controls.Messages.Representations.VenueLocation.generate()
  end

  def given_venue_location_changed(attrs) do
    attrs = Map.get(attrs, :venue, %{})
    venue_location_representation = given_venue_location(attrs)

    attrs = Map.take(attrs, [:venue_id])

    attrs
    |> Map.merge(%{venue_location_representation: venue_location_representation})
    |> Venues.Controls.Messages.Events.VenueLocationChanged.generate()
  end
end

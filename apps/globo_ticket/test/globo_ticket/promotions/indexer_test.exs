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

  test "when act description changed after show is added then show is updated" do
    show_added =
      given_show_added(%{
        act: %{title: "Original Title"}
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

  def given_show_added(attrs) do
    act_description_attrs =
      attrs
      |> Map.get(:act, %{})
      |> Map.take([:title])

    act_description_representation =
      Acts.Controls.Messages.Representations.ActDescription.generate(act_description_attrs)

    act_attrs =
      attrs
      |> Map.get(:act, %{})
      |> Map.take([:act_id])

    act_representation =
      act_attrs
      |> Map.merge(%{act_description_representation: act_description_representation})
      |> Acts.Controls.Messages.Representations.Act.generate()

    venue_attrs = Map.get(attrs, :venue, %{})

    venue_description_representation =
      Venues.Controls.Messages.Representations.VenueDescription.generate(venue_attrs)

    venue_representation =
      Venues.Controls.Messages.Representations.Venue.generate(
        venue_description_representation: venue_description_representation
      )

    Shows.Controls.Messages.Events.ShowAdded.generate(
      act_representation: act_representation,
      venue_representation: venue_representation
    )
  end

  def given_act_description_changed(attrs) do
    act_description_attrs =
      attrs
      |> Map.get(:act, %{})
      |> Map.take([:title])

    act_description_representation =
      Acts.Controls.Messages.Representations.ActDescription.generate(act_description_attrs)

    act_attrs =
      attrs
      |> Map.get(:act, %{})
      |> Map.take([:act_id])

    act_attrs
    |> Map.merge(%{act_description_representation: act_description_representation})
    |> Acts.Controls.Messages.Events.ActDescriptionChanged.generate()
  end
end

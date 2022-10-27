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

  def given_show_added(attrs) do
    act_description_representation =
      Acts.Controls.Messages.Representations.ActDescription.generate(attrs[:act])

    act_representation =
      Acts.Controls.Messages.Representations.Act.generate(
        act_description_representation: act_description_representation
      )

    venue_description_representation =
      Venues.Controls.Messages.Representations.VenueDescription.generate(attrs[:venue])

    venue_representation =
      Venues.Controls.Messages.Representations.Venue.generate(
        venue_description_representation: venue_description_representation
      )

    Shows.Controls.Messages.Events.ShowAdded.generate(
      act_representation: act_representation,
      venue_representation: venue_representation
    )
  end
end

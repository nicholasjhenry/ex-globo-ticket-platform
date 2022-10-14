defmodule GloboTicket.Promotions.ShowsTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Shows.Handlers

  test "act initially has no shows" do
    act_id = given_act()
    shows = Handlers.Queries.list_shows(act_id)
    assert Enum.empty?(shows)
  end

  def given_act do
    act = Acts.Controls.Act.generate()
    Acts.Handlers.Commands.save_act(act)
    act.id
  end
end

defmodule GloboTicket.Promotions.Shows.Show do
  @moduledoc false

  use GloboTicket.Entity

  @primary_key false

  alias GloboTicket.Promotions.Venues

  embedded_schema do
    field :act_id
    embeds_one :venue, Venues.Venue
    field :start_at, :utc_datetime_usec
  end
end

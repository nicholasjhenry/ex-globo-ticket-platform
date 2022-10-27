defmodule GloboTicket.Promotions.Acts.Controls.Messages.Representations.ActDescription do
  @moduledoc false

  use GloboTicket.Control

  alias GloboTicket.Promotions.Acts.Messages

  def generate(attrs \\ []) do
    defaults = %{
      title: Faker.Person.name(),
      image_hash: "/image_1.png",
      modified_date: Clock.Controls.DateTime.example()
    }

    attrs = Enum.into(attrs, defaults)
    struct!(Messages.Representations.ActDescription, attrs)
  end
end

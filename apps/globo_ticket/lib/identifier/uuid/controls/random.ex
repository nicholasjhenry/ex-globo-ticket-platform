defmodule Identifier.Uuid.Controls.Random do
  @moduledoc false

  def example do
    Ecto.UUID.generate()
  end
end

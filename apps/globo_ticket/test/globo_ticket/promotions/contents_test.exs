defmodule GloboTicket.Promotions.ContentsTest do
  use GloboTicket.DataCase

  alias GloboTicket.Promotions.Contents
  alias GloboTicket.Promotions.Contents.Controls
  alias GloboTicket.Promotions.Contents.Handlers

  test "saving content" do
    content = Controls.Content.example()
    result = Handlers.Commands.save_content(content)

    assert {:ok, content} = result
    assert %Contents.Content{} = content
  end
end

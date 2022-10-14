defmodule GloboTicketWeb.FormComponent do
  @moduledoc false
  use GloboTicketWeb, :component

  def input(%{type: "text"} = assigns) do
    assigns = prepare_assigns(assigns, class: [])

    ~H"""
    <div data-resource-attr={@field}>
      <%= if @label do %>
        <%= label(@f, @field, @label) %>
      <% else %>
        <%= label(@f, @field) %>
      <% end %>

      <%= text_input(@f, @field, @input_attrs) %>

      <%= error_tag(@f, @field) %>
    </div>
    """
  end

  def input(%{type: "number"} = assigns) do
    assigns = prepare_assigns(assigns, class: [])

    ~H"""
    <div data-resource-attr={@field}>
      <%= if @label do %>
        <%= label(@f, @field, @label) %>
      <% else %>
        <%= label(@f, @field) %>
      <% end %>

      <%= number_input(@f, @field, @input_attrs) %>

      <%= error_tag(@f, @field) %>
    </div>
    """
  end

  def submit_button(assigns) do
    button_attrs = assigns_to_attributes(assigns, [:label])
    class = []

    assigns =
      assigns
      |> assign(button_attrs: [{:class, class} | button_attrs])

    ~H"""
    <div>
      <%= submit(@label, button_attrs) %>
    </div>
    """
  end

  defp prepare_assigns(assigns, class: class) do
    input_attrs = assigns_to_attributes(assigns, [:f, :field, :label])

    assigns
    |> assign_new(:label, fn -> nil end)
    |> assign(input_attrs: [{:class, class} | input_attrs])
  end
end

defmodule AssertResource do
  @moduledoc false

  defmacro assert_resource(html, resource_type, attr, resource) do
    quote do
      selector =
        "[data-resource-type=#{unquote(resource_type)}] [data-resource-id=#{unquote(resource).id}] [data-resource-attr=#{unquote(attr)}]"

      value = Map.fetch!(unquote(resource), unquote(attr))
      AssertHTML.assert_html(unquote(html), selector, value)
    end
  end

  defmacro assert_resource(html, resource_type, attr, id, value) do
    quote do
      selector =
        "[data-resource-type=#{unquote(resource_type)}] [data-resource-id=#{unquote(id)}] [data-resource-attr=#{unquote(attr)}]"

      AssertHTML.assert_html(unquote(html), selector, unquote(value))
    end
  end

  defmacro refute_resource(html, resource_type, resource) do
    quote do
      selector = "[data-#{unquote(resource_type)}-id=#{unquote(resource).id}]"
      AssertHTML.refute_html(unquote(html), selector)
    end
  end

  defmacro assert_flash(html, type, msg) do
    quote do
      selector = "[data-flash=#{unquote(type)}]"
      AssertHTML.assert_html(unquote(html), selector, unquote(msg))
    end
  end

  defmacro assert_form_error(html, resource_type, attr, msg) do
    quote do
      selector =
        "[data-resource-type=#{unquote(resource_type)}] [data-resource-attr=#{unquote(attr)}] [data-error]"

      value = unquote(html_escape(msg))
      AssertHTML.assert_html(unquote(html), selector, value)
    end
  end

  defp html_escape(unsafe) do
    {:safe, io_data} = Phoenix.HTML.html_escape(unsafe)
    to_string(io_data)
  end
end

defmodule AssertData do
  @moduledoc false

  # e.g. assert_html(html, "[data-venue-id=#{venue.id}] [data-venue-name]", venue.name)
  defmacro assert_data(html, record_identifier, attr, record) do
    quote do
      AssertHTML.assert_html(
        unquote(html),
        "[data-#{unquote(record_identifier)}-id=#{unquote(record).id}] [data-#{unquote(record_identifier)}-#{unquote(attr)}]",
        Map.fetch!(unquote(record), unquote(attr))
      )
    end
  end

  defmacro assert_data(html, record_identifier, attr, id, value) do
    quote do
      AssertHTML.assert_html(
        unquote(html),
        "[data-#{unquote(record_identifier)}-id=#{unquote(id)}] [data-#{unquote(record_identifier)}-#{unquote(attr)}]",
        unquote(value)
      )
    end
  end

  # e.g. refute_html(html, "[data-venue-id=#{venue.id}])
  defmacro refute_data(html, record_identifier, record) do
    quote do
      AssertHTML.refute_html(
        unquote(html),
        "[data-#{unquote(record_identifier)}-id=#{unquote(record).id}]"
      )
    end
  end

  defmacro assert_flash(html, type, msg) do
    quote do
      AssertHTML.assert_html(
        unquote(html),
        "[data-flash-#{unquote(type)}]",
        unquote(msg)
      )
    end
  end

  # assert_html(html, "[data-venue-name] [data-error]", html_escape("can't be blank"))
  defmacro assert_form_error(html, form_identifier, record_identifier, attr, msg) do
    quote do
      AssertHTML.assert_html(
        unquote(html),
        "#{unquote(form_identifier)} [data-#{unquote(record_identifier)}-#{unquote(attr)}] [data-error]",
        unquote(html_escape(msg))
      )
    end
  end

  defp html_escape(unsafe) do
    {:safe, io_data} = Phoenix.HTML.html_escape(unsafe)
    to_string(io_data)
  end
end

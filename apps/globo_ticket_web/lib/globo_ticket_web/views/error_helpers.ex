defmodule GloboTicketWeb.ErrorHelpers do
  @moduledoc false

  use Phoenix.HTML

  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        data: [error: true],
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(GloboTicketWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(GloboTicketWeb.Gettext, "errors", msg, opts)
    end
  end
end

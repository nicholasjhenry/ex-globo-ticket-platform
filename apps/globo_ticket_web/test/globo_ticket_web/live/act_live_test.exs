defmodule GloboTicketWeb.ActLiveTest do
  use GloboTicketWeb.ConnCase

  import Phoenix.LiveViewTest
  import Phoenix.Resource.Assertions

  alias GloboTicket.Promotions.Acts
  alias GloboTicket.Promotions.Contents
  alias Verity.Identifier

  @form_identifier "#act-form"

  defp create_act(_context) do
    act = Acts.Controls.Act.example()
    {:ok, _act} = Acts.Handlers.Commands.save_act(act)
    %{act: act}
  end

  describe "Index" do
    setup [:create_act]

    test "lists all acts", %{conn: conn, act: act} do
      {:ok, _index_live, html} = list_acts(conn)

      html
      |> assert_html("h1", "Listing Acts")
      |> assert_resource(:act, :title, act)
    end

    test "saves new act", %{conn: conn} do
      act_id = Identifier.Uuid.Controls.Random.example()
      {:ok, index_live, _html} = list_acts(conn, id: act_id)

      index_live
      |> new_act()
      |> assert_html("h2", "New Act")

      assert_patch(index_live, Routes.act_index_path(conn, :new, act_id))

      index_live
      |> change_form(act: Acts.Controls.Act.Attrs.invalid())
      |> assert_form_error(:act, :title, "can't be blank")

      create_attrs = Acts.Controls.Act.Attrs.valid()

      image =
        file_input(index_live, "#act-form", :image, [
          Contents.Controls.Image.example()
        ])

      assert render_upload(image, "image.png") =~ "100%"

      {:ok, _, html} =
        index_live
        |> submit_form(act: create_attrs)
        |> follow_redirect(conn, Routes.act_index_path(conn, :index))

      html
      |> assert_flash(:info, "Act created successfully")
      |> assert_resource(:act, :title, act_id, create_attrs.title)
    end

    test "updates act in listing", %{conn: conn, act: act} do
      {:ok, index_live, _html} = list_acts(conn)

      index_live
      |> edit_act(act)
      |> assert_html("h2", "Edit Act")

      assert_patch(index_live, Routes.act_index_path(conn, :edit, act))

      index_live
      |> form(@form_identifier, act: Acts.Controls.Act.Attrs.invalid())
      |> render_change()
      |> assert_form_error(:act, :title, "can't be blank")

      update_attrs = Acts.Controls.Act.Attrs.valid(title: "Changed Title")

      {:ok, _, html} =
        index_live
        |> form(@form_identifier, act: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.act_index_path(conn, :index))

      html
      |> assert_flash(:info, "Act updated successfully")
      |> assert_resource(:act, :title, act.id, update_attrs.title)
    end

    test "deletes act in listing", %{conn: conn, act: act} do
      {:ok, index_live, _html} = list_acts(conn)

      index_live
      |> delete_act(act)
      |> refute_resource(:act, act)
    end

    defp list_acts(conn, params \\ %{}) do
      live(conn, Routes.act_index_path(conn, :index, params))
    end

    defp new_act(live) do
      live
      |> element("[data-resource-type=act] [data-action=new]")
      |> render_click()
    end

    defp edit_act(live, act) do
      live
      |> element("[data-resource-id=#{act.id}] [data-action=edit]")
      |> render_click()
    end

    defp delete_act(live, act) do
      live
      |> element("[data-resource-id=#{act.id}] [data-action=delete]")
      |> render_click()
    end
  end

  describe "Show" do
    setup [:create_act]

    test "displays act", %{conn: conn, act: act} do
      {:ok, _show_live, html} = show_act(conn, act)

      html
      |> assert_html("h1", "Show Act")
      |> assert_resource(:act, :title, act)
    end

    test "updates act within modal", %{conn: conn, act: act} do
      {:ok, show_live, _html} = show_act(conn, act)

      show_live
      |> edit_act()
      |> assert_html("h2", "Edit Act")

      assert_patch(show_live, Routes.act_show_path(conn, :edit, act))

      show_live
      |> form(@form_identifier, act: Acts.Controls.Act.Attrs.invalid())
      |> render_change()
      |> assert_form_error(:act, :title, "can't be blank")

      update_attrs = Acts.Controls.Act.Attrs.valid(title: "Changed Title")
      {:ok, _, html} = update_act(conn, show_live, act, update_attrs)

      html
      |> assert_flash(:info, "Act updated successfully")
      |> assert_resource(:act, :title, act.id, "Changed Title")
    end

    defp edit_act(live) do
      live
      |> element("[data-resource-type=act] [data-action=edit]")
      |> render_click()
    end

    defp show_act(conn, act) do
      live(conn, Routes.act_show_path(conn, :show, act))
    end

    defp update_act(conn, live, act, attrs) do
      live
      |> form(@form_identifier, act: attrs)
      |> render_submit()
      |> follow_redirect(conn, Routes.act_show_path(conn, :show, act))
    end
  end

  defp change_form(live, attrs) do
    live
    |> form(@form_identifier, attrs)
    |> render_change()
  end

  defp submit_form(live, attrs) do
    live
    |> form(@form_identifier, attrs)
    |> render_submit()
  end
end

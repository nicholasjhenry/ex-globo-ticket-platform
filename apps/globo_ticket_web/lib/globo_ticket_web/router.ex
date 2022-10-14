defmodule GloboTicketWeb.Router do
  use GloboTicketWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GloboTicketWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GloboTicketWeb do
    pipe_through :browser

    get "/", PageController, :index

    # Resource: Venues
    live "/venues", VenueLive.Index, :index
    live "/venues/new/:id", VenueLive.Index, :new
    live "/venues/:id/edit", VenueLive.Index, :edit

    live "/venue/:id", VenueLive.Show, :show
    live "/venue/:id/show/edit", VenueLive.Show, :edit

    # Resource: Acts
    live "/acts", ActLive.Index, :index
    live "/acts/new/:id", ActLive.Index, :new
    live "/acts/:id/edit", ActLive.Index, :edit

    live "/act/:id", ActLive.Show, :show
    live "/act/:id/show/edit", ActLive.Show, :edit
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GloboTicketWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

defmodule KanbanWeb.Router do
  use KanbanWeb, :router

  # pipeline :browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_live_flash
  #   plug :put_root_layout, html: {KanbanWeb.Layouts, :root}
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  # scope "/", KanbanWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  # if Application.compile_env(:kanban, :dev_routes) do
  #   # If you want to use the LiveDashboard in production, you should put
  #   # it behind authentication and allow only admins to access it.
  #   # If your application does not have an admins-only section yet,
  #   # you can use Plug.BasicAuth to set up some basic authentication
  #   # as long as you are also using SSL (which you should anyway).
  #   import Phoenix.LiveDashboard.Router

  #   scope "/dev" do
  #     pipe_through :browser

  #     live_dashboard "/dashboard", metrics: KanbanWeb.Telemetry
  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end

  forward "/api", Absinthe.Plug, schema: KanbanWeb.Schema
end

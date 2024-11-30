defmodule SnowbonkerWeb.Router do
  use SnowbonkerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SnowbonkerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnowbonkerWeb do
    pipe_through :browser

    live "/", SnowcrewLive.Index, :index
  end
end

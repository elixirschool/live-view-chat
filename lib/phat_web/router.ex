defmodule PhatWeb.Router do
  use PhatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhatWeb do
    pipe_through :browser

    resources "/users", UserController

    resources "/sessions", SessionController,
      only: [:new, :create, :delete],
      singleton: true

    resources "/chats", ChatController
  end
end

defmodule Tudo.Router do
  use Tudo.Web, :router

  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Tudo do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", Tudo do
    pipe_through :browser

    delete "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end
  # Other scopes may use custom stacks.
  # scope "/api", Tudo do
  #   pipe_through :api
  # end
end

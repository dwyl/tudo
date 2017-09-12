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
    get "/search", PageController, :search
  end

  scope "/labels", Tudo do
    pipe_through :browser

    get "/", UnlabelledController, :index
    get "/search", UnlabelledController, :search
  end

  scope "/auth", Tudo do
    pipe_through :browser

    delete "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/issues", Tudo do
    get "/", GithubController, :index
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Tudo do
    pipe_through :api

    post "/hooks", HookController, :create
  end
end

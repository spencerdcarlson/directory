defmodule DirectoryWeb.Router do
  use DirectoryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DirectoryWeb do
    pipe_through :browser

    get "/", PageController, :index
    #    get "/*path", PageController, :index # react routing
  end

  scope "/api/ds", DirectoryWeb do
    pipe_through [:browser]
    get "/csrf", AuthenticationController, :csrf
  end

  scope "/auth", DirectoryWeb do
    pipe_through [:browser]

    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    post "/:provider/callback", AuthenticationController, :callback
    post "/logout", AuthenticationController, :delete
  end
end

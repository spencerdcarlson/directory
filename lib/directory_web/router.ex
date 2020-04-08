defmodule DirectoryWeb.Router do
  use DirectoryWeb, :router

  pipeline :session do
    # requires the _directory_key cookie be set in request
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DirectoryWeb do
    pipe_through :session

    get "/", PageController, :index
    #    get "/*path", PageController, :index # react routing
  end

  scope "/api/ds", DirectoryWeb do
    pipe_through [:session]
    get "/csrf", AuthenticationController, :csrf
    get "/user/uid", AuthenticationController, :user_uid
  end

  scope "/auth", DirectoryWeb do
    pipe_through [:session]

    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    post "/:provider/callback", AuthenticationController, :callback
    post "/logout", AuthenticationController, :delete
  end
end

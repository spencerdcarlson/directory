defmodule DirectoryWeb.Router do
  use DirectoryWeb, :router

  pipeline :session do
    # requires the _directory_key cookie be set in request
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/ds", DirectoryWeb do
    pipe_through [:session]
    get "/csrf", AuthenticationController, :csrf
    get "/user/uid", AuthenticationController, :user_uid
    post "/logout", AuthenticationController, :delete
  end

  scope "/auth", DirectoryWeb do
    pipe_through [:session]

    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    post "/:provider/callback", AuthenticationController, :callback
    post "/logout", AuthenticationController, :delete
  end
end

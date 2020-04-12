defmodule DirectoryWeb.Router do
  use DirectoryWeb, :router

  pipeline :session do
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
    get "/session/whoami", AuthenticationController, :whoami_session
    get "/jwt/whoami", AuthenticationController, :whoami_jwt
    post "/logout", AuthenticationController, :delete
  end

  scope "/auth", DirectoryWeb do
    # Uberauth implementation
    pipe_through [:session]
    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    post "/:provider/callback", AuthenticationController, :callback
  end
end

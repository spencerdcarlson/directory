# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :directory,
  ecto_repos: [Directory.Repo],
  generators: [migration: true],
  google_client_id: System.get_env("GOOGLE_CLIENT_ID")

# Configures the endpoint
config :directory, DirectoryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V2ymhPZlxm00KyWzblu01NCbZ3ieSYFiOmNnJYF7gmMtls/DiXvEcFfRIiyzVpA9",
  render_errors: [view: DirectoryWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Directory.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google, [default_scope: "openid profile email", access_type: "offline"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

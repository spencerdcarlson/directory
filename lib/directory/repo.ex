defmodule Directory.Repo do
  use Ecto.Repo,
    otp_app: :directory,
    adapter: Ecto.Adapters.Postgres
end

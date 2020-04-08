defmodule Directory.Repo.Migrations.CreateGoogleAuthInfo do
  use Ecto.Migration

  def change do
    create table(:google_auth_info) do
      add :refresh_token, :string
      add :scopes, :string
      add :token, :string
      add :sub, :string
      add :expires_at, :utc_datetime
      add :uid, :string
      add :description, :string
      add :email, :string
      add :first_name, :string
      add :image, :string
      add :last_name, :string
      add :location, :string
      add :name, :string
      add :nickname, :string
      add :phone, :string
      add :profile_url, :string
      add :website_url, :string
      add :raw_user, :json
      add :raw_info, :json
      add :user_id, references(:users)
      timestamps()
    end

    create(unique_index(:google_auth_info, [:uid]))
  end
end

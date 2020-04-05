defmodule Directory.Repo.Migrations.CreateGoogleAuthInfo do
  use Ecto.Migration

  def change do
    create table(:google_auth_info, primary_key: false) do
      add :id, :binary_id, primary_key: true
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
      add :user_id, references(:users, type: :binary_id)
      timestamps()
    end

    create(unique_index(:google_auth_info, [:uid]))
  end
end

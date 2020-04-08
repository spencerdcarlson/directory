defmodule Directory.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :uuid, null: false
      timestamps()
    end
  end
end

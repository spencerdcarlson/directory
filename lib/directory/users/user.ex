defmodule Directory.User do
  @moduledoc """
  User changeset
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Directory.{GoogleAuthInfo, User}

  @derive {Jason.Encoder, only: [:auth_info]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_one :auth_info, GoogleAuthInfo, on_replace: :delete
    timestamps()
  end

  def changeset(user, attrs \\ %{})

  def changeset(nil, attrs) do
    changeset(%User{}, attrs)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
    |> cast_assoc(:auth_info)
  end

  def with_guid(user, uid) do
    from(u in user,
      join: ai in GoogleAuthInfo,
      on: u.id == ai.user_id,
      where: ai.uid == ^uid,
      preload: [auth_info: ai]
    )
  end
end

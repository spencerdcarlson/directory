defmodule Directory.User do
  @moduledoc """
  User changeset
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Directory.{GoogleAuthInfo}

  @derive {Jason.Encoder, only: [:auth_info]}
  @fields [:uid]
  @required [:uid]

  schema "users" do
    field :uid, Ecto.UUID
    has_one :auth_info, GoogleAuthInfo, on_replace: :delete
    timestamps()
  end

  def changeset(user = %__MODULE__{}, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> cast_assoc(:auth_info)
  end

  def with_guid(user = __MODULE__, uid) do
    from(u in user,
      join: ai in GoogleAuthInfo,
      on: u.id == ai.user_id,
      where: ai.uid == ^uid,
      preload: [auth_info: ai]
    )
  end

  def with_id(user = __MODULE__, id), do: from(u in user, where: u.id == ^id)
end

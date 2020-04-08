defmodule Directory.GoogleAuthInfo do
  @moduledoc """
  Google Authentication Changeset
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Directory.User

  @fields [
    :uid,
    :description,
    :email,
    :first_name,
    :image,
    :last_name,
    :location,
    :name,
    :nickname,
    :phone,
    :profile_url,
    :website_url,
    :refresh_token,
    :token,
    :sub,
    :expires_at,
    :scopes,
    :raw_user,
    :raw_info
  ]
  @required [:uid]

  @derive {Jason.Encoder, only: @fields}

  schema "google_auth_info" do
    field :uid, :string
    field :refresh_token, :string
    field :token, :string
    field :sub, :string
    field :expires_at, :utc_datetime
    field :scopes, :string
    field :description, :string
    field :email, :string
    field :first_name, :string
    field :image, :string
    field :last_name, :string
    field :location, :string
    field :name, :string
    field :nickname, :string
    field :phone, :string
    field :profile_url, :string
    field :website_url, :string
    field :raw_user, :map
    field :raw_info, :map
    belongs_to :user, User

    timestamps()
  end

  def changeset(g_auth_info, attrs \\ %{})

  def changeset(nil, attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(g_auth_info, attrs) do
    g_auth_info
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> unique_constraint(:uid)
  end
end

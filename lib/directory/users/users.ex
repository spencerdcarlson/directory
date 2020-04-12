defmodule Directory.Users do
  @moduledoc """
  Users context
  """

  alias OAuth2.AccessToken
  alias Ueberauth.{Auth, Auth.Extra}

  alias Directory.{Crypto.JWTManager, Repo}
  alias Directory.User
  alias Directory.Utility.Map, as: MapUtility
  alias Ecto.Changeset

  require Logger

  def get(nil), do: %User{}

  def get(id) do
    User
    |> User.with_id(id)
    |> Repo.one()
  end

  def find_or_create(%Auth{provider: :identity}), do: {:error, :basic_auth_not_supported}

  def find_or_create(auth = %Auth{}) do
    with {:get_jwt, {:ok, jwt}} <- {:get_jwt, jwt(auth)},
         {:validate_jwt, {:ok, _}} <- {:validate_jwt, JWTManager.verify_and_validate(jwt)},
         {:find_user, {:ok, user}} <- {:find_user, find(auth)},
         {:upsert, {:ok, user}} <- {:upsert, upsert(user, auth)} do
      {:ok, %{user: user, jwt: jwt}}
    else
      {error, {:error, _detail}} ->
        Logger.error("User find or create error. Error: " <> inspect(error))
        {:error, error}
    end
  end

  defp jwt(%Auth{
         provider: :google,
         extra: %Extra{raw_info: %{token: %AccessToken{other_params: %{"id_token" => jwt}}}}
       }) do
    {:ok, jwt}
  end

  defp jwt(_), do: {:error, :get_jwt_from_auth}

  defp find(%Auth{provider: :google, uid: uid}) do
    {:ok,
     User
     |> User.with_guid(uid)
     |> Repo.one()
     |> Repo.preload(:auth_info)}
  end

  defp find(_), do: {:error, :find_user_not_supported}

  defp upsert(nil, auth = %Auth{provider: :google}) do
    Logger.info("User does not exist, creating a new user.")
    upsert(%User{uid: Ecto.UUID.generate()}, auth)
  end

  defp upsert(user = %User{}, auth = %Auth{provider: :google}) do
    with {:map_auth_info, {:ok, auth_info}} <- {:map_auth_info, map_auth_info(auth)},
         {:changeset, changeset = %Changeset{valid?: true}} <-
           {:changeset, User.changeset(user, auth_info)},
         {:upsert, {:ok, user = %User{id: id}}} <- {:upsert, Repo.insert_or_update(changeset)} do
      Logger.info("User #{id} was updated.")
      {:ok, user}
    else
      {step, detail} ->
        Logger.error("error updating user. Error: " <> inspect(detail))
        {:error, step}
    end
  end

  defp map_auth_info(auth = %Auth{provider: :google}) do
    # Map Ueberauth.Auth to Directory.GoogleAuthInfo
    auth = MapUtility.to_map(auth)

    auth_info =
      %{
        uid: MapUtility.dig(auth, [:uid]),
        refresh_token: MapUtility.dig(auth, [:credentials, :refresh_token]),
        scopes: auth |> MapUtility.dig([:credentials, :scopes]) |> hd(),
        token: MapUtility.dig(auth, [:credentials, :token]),
        sub: MapUtility.dig(auth, [:extra, :raw_info, :user, "sub"]),
        expires_at: auth |> MapUtility.dig([:credentials, :expires_at]) |> DateTime.from_unix!(),
        description: MapUtility.dig(auth, [:info, :description]),
        email: MapUtility.dig(auth, [:info, :email]),
        first_name: MapUtility.dig(auth, [:info, :first_name]),
        image: MapUtility.dig(auth, [:info, :image]),
        last_name: MapUtility.dig(auth, [:info, :last_name]),
        location: MapUtility.dig(auth, [:info, :location]),
        name: MapUtility.dig(auth, [:info, :name]),
        nickname: MapUtility.dig(auth, [:info, :nickname]),
        phone: MapUtility.dig(auth, [:info, :phone]),
        profile_url: MapUtility.dig(auth, [:info, :urls, :profile]),
        website_url: MapUtility.dig(auth, [:info, :urls, :website]),
        raw_user: MapUtility.dig(auth, [:extra, :raw_info, :user]),
        raw_info: MapUtility.dig(auth, [:info])
      }
      |> Enum.reduce(%{}, &filter_nil_values/2)

    # filter out nil values, to keep any data about a user that no longer exists
    # and doesn't have a a new value for it.
    # TODO this doesn't actually work, because I can't get Repo.insert/2 to handle on_conflict to only update a list of fields
    # so it is always setting them as nil if they don't exist. Might need to first fetch the record
    # from the DB and then merge it will possible changes
    # or convert this into a multi step transaction. 1 update auth record, 2 update user.

    Map.has_key?(auth_info, :description)

    {:ok, %{auth_info: auth_info}}
  end

  defp map_auth_info(_), do: {:error, :uber_auth_type_not_supported}

  defp filter_nil_values({key, value}, acc) do
    if is_nil(value), do: acc, else: Map.put(acc, key, value)
  end
end

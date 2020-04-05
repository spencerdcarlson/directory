defmodule Directory.Users do
  @moduledoc """
  Users context
  """

  alias OAuth2.AccessToken
  alias Ueberauth.{Auth, Auth.Extra}

  alias Directory.{Crypto.JWTManager, Repo}
  alias Directory.User

  require Logger

  def find_or_create(auth = %Auth{provider: :identity}) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(auth = %Auth{}) do
    with {:get_jwt, {:ok, jwt}} <- {:get_jwt, jwt(auth)},
         {:validate_jwt, {:ok, _}} <- {:validate_jwt, JWTManager.verify_and_validate(jwt)},
         {:upsert, {:ok, user}} <- {:upsert, upsert(find(auth), auth)} do
      {:ok, %{user: user, jwt: jwt}}
    else
      {:get_jwt, {:error, error}} ->
        Logger.error(error)
        {:error, "Could not get JWT from google redirect"}

      {:validate_jwt, {:error, error}} ->
        Logger.error(error)
        {:validate_jwt, "Could not decode or verify JWT"}

      {:upsert, {:error, error}} ->
        Logger.error(error)
        {:upsert, "Could not upsert user info"}

      error ->
        Logger.error(error)
        {:error, "Unknown error"}
    end
  end

  defp jwt(%Auth{
         provider: :google,
         extra: %Extra{raw_info: %{token: %AccessToken{other_params: %{"id_token" => jwt}}}}
       }),
       do: {:ok, jwt}

  defp jwt(auth), do: {:error, auth}

  def find(%Auth{provider: :google, uid: uid}) do
    User
    |> User.with_guid(uid)
    |> Repo.one()
    |> Repo.preload(:auth_info)
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp upsert(record, auth = %Auth{provider: :google}) do
    changes = %{
      uid: auth.uid,
      refresh_token: auth.credentials.refresh_token,
      scopes: hd(auth.credentials.scopes),
      token: auth.credentials.token,
      sub: auth.extra.raw_info.user["sub"],
      expires_at: DateTime.from_unix!(auth.credentials.expires_at),
      description: auth.info.description,
      email: auth.info.email,
      first_name: auth.info.first_name,
      image: auth.info.image,
      last_name: auth.info.last_name,
      location: auth.info.location,
      name: auth.info.name,
      nickname: auth.info.nickname,
      phone: auth.info.phone,
      profile_url: auth.info.urls.profile,
      website_url: auth.info.urls.website
    }

    result =
      record
      |> User.changeset(%{auth_info: changes})
      |> Repo.insert_or_update()

    case result do
      {:ok, schema} ->
        {:ok, schema}

      {:error, changeset} ->
        Logger.error("error inserting user. #{inspect(changeset)}")
        {:error, auth}
    end
  end

  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth), avatar: avatar_from_auth(auth)}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if name == [], do: auth.info.nickname, else: Enum.join(name, " ")
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end

defmodule DirectoryWeb.AuthenticationController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use DirectoryWeb, :controller
  require Logger
  plug Ueberauth

  alias Directory.{Crypto.JWTManager, Users}
  alias Plug.CSRFProtection
  alias Ueberauth.Strategy.Helpers

  def csrf(conn, _params) do
    csrf = CSRFProtection.get_csrf_token()

    json(conn, %{csrf: csrf})
  end

  def whoami_session(conn, _params) do
    user =
      conn
      |> get_session(:user_id)
      |> Users.get()

    json(conn, %{user: user})
  end

  def whoami_jwt(conn, _params) do
    jwt = conn |> Map.get(:req_cookies, %{}) |> Map.get("id_token")

    user =
      case JWTManager.verify_and_validate(jwt) do
        {:ok, claims} -> claims |> Map.get("sub") |> Users.get(type: :google_sub)
        _ -> %{}
      end

    json(conn, %{user: user})
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> json(%{logout: true})
  end

  def callback(conn = %{assigns: %{ueberauth_failure: _fails}}, _params) do
    redirect(conn, to: "/")
  end

  def callback(conn = %{assigns: %{ueberauth_auth: auth}}, _params) do
    Logger.debug("Auth: #{inspect(auth)}")

    case Users.find_or_create(auth) do
      {:ok, %{user: user, jwt: jwt}} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_session(:user_uid, user.uid)
        |> put_resp_cookie("id_token", jwt, http_only: false, extra: "SameSite=Strict")
        |> configure_session(renew: true)
        |> redirect(external: redirect_url())

      {:error, reason} when is_atom(reason) ->
        Logger.error("Error during login. Error: " <> inspect(reason))
        json(conn, %{login: false, errors: [reason]})

      error ->
        Logger.error("Unknown error during login. " <> inspect(error))
        json(conn, %{login: false, errors: [:unknown]})
    end
  end

  defp redirect_url do
    Application.get_env(:directory, :redirect_url, "http://localhost:8080")
  end
end

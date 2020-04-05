defmodule DirectoryWeb.AuthenticationController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use DirectoryWeb, :controller
  plug Ueberauth

  alias Directory.Users
  alias Plug.CSRFProtection
  alias Ueberauth.Strategy.Helpers

  def csrf(conn, _params) do
    csrf = CSRFProtection.get_csrf_token()

    conn
    |> put_resp_cookie("csrf", csrf, http_only: false, extra: "SameSite=Strict")
    |> json(%{csrf: csrf})
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn = %{assigns: %{ueberauth_failure: _fails}}, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(conn = %{assigns: %{ueberauth_auth: auth}}, _params) do
    #    case UserFromAuth.find_or_create(auth) do
    case Users.find_or_create(auth) do
      {:ok, %{user: user, jwt: jwt}} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> put_resp_cookie("id_token", jwt)
        |> put_resp_cookie("csrf", CSRFProtection.get_csrf_token(), http_only: false)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end

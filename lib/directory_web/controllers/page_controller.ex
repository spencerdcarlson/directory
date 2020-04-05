defmodule DirectoryWeb.PageController do
  use DirectoryWeb, :controller
  plug Ueberauth

  def index(conn, _params) do
    json(conn, %{current_user: get_session(conn, :user_id)})
  end
end

defmodule PhatWeb.SessionController do
  use PhatWeb, :controller
  alias PhatWeb.Services.Session

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => user_params}) do
    case Session.authenticate(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/chats")

      :error ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/sessions/new")
  end
end

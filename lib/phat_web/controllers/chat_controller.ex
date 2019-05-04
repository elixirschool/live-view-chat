defmodule PhatWeb.ChatController do
  use PhatWeb, :controller
  alias Phat.Chats
  alias Phoenix.LiveView
  alias PhatWeb.ChatLiveView
  plug :authenticate_user

  def index(conn, _params) do
    chats = Chats.list_chats()
    render(conn, "index.html", chats: chats)
  end

  def show(conn, %{"id" => chat_id}) do
    chat = Chats.get_chat(chat_id)

    LiveView.Controller.live_render(
      conn,
      ChatLiveView,
      session: %{chat: chat, current_user: conn.assigns.current_user}
    )
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/sessions/new")
        |> halt()

      user_id ->
        assign(conn, :current_user, Phat.Accounts.get_user(user_id))
    end
  end
end

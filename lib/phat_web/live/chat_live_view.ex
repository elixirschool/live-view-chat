defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats
  alias PhatWeb.Presence

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user}, socket) do
    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user
     )}
  end
end

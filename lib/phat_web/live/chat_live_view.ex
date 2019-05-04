defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(session, socket) do
    {:ok,
     assign(socket,
       chat: session.chat,
       message: Chats.change_message(),
       current_user: session.current_user
     )}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    chat = Chats.create_message(socket.assigns.chat, message_params)
    {:noreply, assign(socket, chat: chat)}
  end
end

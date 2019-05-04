defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats
  alias PhatWeb.Presence

  defp topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user}, socket) do
    track(topic(chat.id), current_user)
    subscribe(topic(chat.id))

    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user,
       users: presences(chat.id)
     )}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply,
     assign(socket,
       users: presences(socket.assigns.chat.id)
     )}
  end

  def handle_info(%{event: "save", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_event("save", %{"message" => message_params}, socket = %{assigns: %{chat: chat}}) do
    chat = Chats.create_message(chat, message_params)
    PhatWeb.Endpoint.broadcast_from(self(), topic(chat.id), "save", %{chat: chat})
    {:noreply, assign(socket, chat: chat)}
  end

  defp presences(chat_id) do
    Presence.list("chat:#{chat_id}")
    |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
    end)
  end

  defp track(topic, user) do
    Presence.track(self(), topic, user.id, %{
       typing: false,
       first_name: user.first_name,
       user_id: user.id
     })
  end

  defp subscribe(topic) do
    PhatWeb.Endpoint.subscribe(topic)
  end
end

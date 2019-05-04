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

  def handle_info(%{event: "message", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_event("message", %{"message" => message_params}, socket = %{assigns: %{chat: chat}}) do
    chat = Chats.create_message(chat, message_params)
    PhatWeb.Endpoint.broadcast_from(self(), topic(chat.id), "message", %{chat: chat})
    {:noreply, assign(socket, chat: chat)}
  end

  def handle_event("typing", _value, socket = %{assigns: %{chat: chat, current_user: user}} ) do
    update_presence(topic(chat.id), user, %{typing: true})
    {:noreply, socket}
  end

  def handle_event("stop_typing", _value, socket = %{assigns: %{chat: chat, current_user: user}} ) do
    update_presence(topic(chat.id), user, %{typing: false})
    {:noreply, socket}
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

  defp update_presence(topic, user, payload) do
    metas = Presence.get_by_key(topic, user.id)[:metas]
    |> List.first
    |> Map.merge(payload)
    Presence.update(self(), topic, user.id, metas)
  end

  defp subscribe(topic) do
    PhatWeb.Endpoint.subscribe(topic)
  end
end

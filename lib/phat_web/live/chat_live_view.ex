defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats
  alias PhatWeb.Presence

  defp live_view_topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user, session_uuid: session_uuid}, socket) do
    Presence.track_presence(
      self(),
      live_view_topic(chat.id),
      current_user.id,
      default_user_presence_payload(current_user)
    )

    PhatWeb.Endpoint.subscribe(live_view_topic(chat.id))

    {:ok, assign(socket,
      chat: chat,
      message: Chats.change_message(),
      current_user: current_user,
      users: Presence.list_presences(live_view_topic(chat.id)),
      username_colors: username_colors(chat),
      session_uuid: session_uuid,
      token: Phoenix.Token.sign(PhatWeb.Endpoint, "user salt", session_uuid)
    )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{chat: chat}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(live_view_topic(chat.id))
     )}
  end

  def handle_info(%{event: "new_message", payload: state}, socket) do
    send(self(), {:send_to_event_bus, "new_message"})
    {:noreply, assign(socket, state)}
  end

  def handle_info({:send_to_event_bus, msg}, socket = %{assigns: %{session_uuid: session_uuid}}) do
    [{_pid, channel_pid}] = Registry.lookup(Registry.SessionRegistry, session_uuid)
    send(channel_pid, msg)
    {:noreply, socket}
  end

  def handle_event("new_message", %{"message" => %{"content" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("new_message", %{"message" => message_params}, socket) do
    chat = Chats.create_message(message_params)
    PhatWeb.Endpoint.broadcast(live_view_topic(chat.id), "new_message", %{chat: chat})
    {:noreply, assign(socket, chat: chat, message: Chats.change_message())}
  end

  def handle_event("typing", _value, socket = %{assigns: %{chat: chat, current_user: user}}) do
    Presence.update_presence(self(), live_view_topic(chat.id), user.id, %{typing: true})
    {:noreply, socket}
  end

  def handle_event(
        "stop_typing",
        value,
        socket = %{assigns: %{chat: chat, current_user: user, message: message}}
      ) do
    message = Chats.change_message(message, %{content: value})
    Presence.update_presence(self(), live_view_topic(chat.id), user.id, %{typing: false})
    {:noreply, assign(socket, message: message)}
  end

  defp default_user_presence_payload(user) do
    %{
      typing: false,
      first_name: user.first_name,
      email: user.email,
      user_id: user.id
    }
  end

  defp random_color do
    hex_code =
      ColorStream.hex()
      |> Enum.take(1)
      |> List.first()

    "##{hex_code}"
  end

  def username_colors(chat) do
    Enum.map(chat.messages, fn message -> message.user end)
    |> Enum.map(fn user -> user.email end)
    |> Enum.uniq()
    |> Enum.into(%{}, fn email -> {email, random_color()} end)
  end
end

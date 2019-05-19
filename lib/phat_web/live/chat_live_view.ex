defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats
  alias PhatWeb.Presence

  defp topic(chat_id), do: "chat:#{chat_id}"

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user}, socket) do
    Presence.track_presence(
      self(),
      topic(chat.id),
      current_user.id,
      default_user_presence_payload(current_user)
    )

    PhatWeb.Endpoint.subscribe(topic(chat.id))

    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user,
       users: Presence.list_presences(topic(chat.id)),
       username_colors: username_colors(chat)
     )}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{chat: chat}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(chat.id))
     )}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
    # 2
    IO.puts("HANDLING LV BROADCAST")
    send(self(), {:send_message_to_event_bus, "message_sent"})
    IO.puts("RE-RENDERING OTHER LV #{socket.assigns.current_user.id}")
    {:noreply, assign(socket, state)}
  end

  def handle_info({:send_message_to_event_bus, "message_sent"}, socket) do
    # 3
    IO.puts("SENDING TO CHANNEL...")

    Presence.list_presences("event_bus:#{socket.assigns.chat.id}")
    |> Enum.each(fn data ->
      pid = data.channel_pid |> :base64.decode() |> :erlang.binary_to_term
      send(pid, {:new_message, %{current_user_id: socket.assigns.current_user.id}})
    end)

    # PhatWeb.Endpoint.broadcast!("event_bus:#{socket.assigns.chat.id}", "new_chat_message", %{
    #   current_user_id: socket.assigns.current_user.id
    # })

    {:noreply, socket}
  end

  def handle_event("message", %{"message" => %{"content" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("message", %{"message" => message_params}, socket) do
    # 1
    IO.puts("RECEIVING MESSAGE...")
    chat = Chats.create_message(message_params)
    PhatWeb.Endpoint.broadcast(topic(chat.id), "message", %{chat: chat})
    IO.puts("RE-RENDERING SELF...")
    {:noreply, assign(socket, chat: chat, message: Chats.change_message())}
  end

  def handle_event("typing", _value, socket = %{assigns: %{chat: chat, current_user: user}}) do
    Presence.update_presence(self(), topic(chat.id), user.id, %{typing: true})
    {:noreply, socket}
  end

  def handle_event(
        "stop_typing",
        value,
        socket = %{assigns: %{chat: chat, current_user: user, message: message}}
      ) do
    message = Chats.change_message(message, %{content: value})
    Presence.update_presence(self(), topic(chat.id), user.id, %{typing: false})
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

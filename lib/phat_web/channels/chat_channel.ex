defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel

  def join("event_bus:" <> chat_id_and_session_uuid, _message, socket) do
    # [_chat_id, session_uuid] = String.split(chat_id_and_session_uuid, ":")
    # socket = assign(socket, :session_uuid, session_uuid)
    IO.puts(chat_id_and_session_uuid)
    IO.puts("JOINING...")
    {:ok, socket}
  end

  intercept ["new_message"]

  def handle_out("new_message", _payload, socket) do
    IO.puts("HANDLING OUT...")
    push(socket, "new_chat_message", %{})
    # if  current_user_id == socket.assigns.current_user_id do
    # end
    {:noreply, socket}
  end
end

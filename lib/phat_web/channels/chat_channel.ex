defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel

  def join("event_bus:" <> _chat_id, _message, socket) do
    {:ok, socket}
  end

  intercept ["new_message"]

  def handle_out("new_message", %{current_user_id: current_user_id}, socket) do
    if  current_user_id == socket.assigns.current_user_id do
      push(socket, "new_chat_message", %{})
    end
    {:noreply, socket}
  end
end

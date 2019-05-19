defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel

  defp topic(chat_id), do: "event_bus:#{chat_id}"

  def join("event_bus:" <> chat_id, _message, socket) do
    PhatWeb.Endpoint.subscribe(topic(chat_id))
    {:ok, socket}
  end

  def handle_out("new_message", %{current_user_id: current_user_id}, socket) do
    if  current_user_id == socket.assigns.current_user_id do
      push(socket, "new_chat_message", %{})
    end
    {:noreply, socket}
  end
end

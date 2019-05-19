defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel
  alias PhatWeb.Presence
  alias PhatWeb.Pid

  defp topic(chat_id), do: "event_bus:#{chat_id}"

  def join("event_bus:" <> chat_id, _message, socket) do
    pid = Pid.to_binary(self())
    user_id = socket.assigns.current_user_id

    Presence.track(self(), topic(chat_id), user_id, %{
      channel_pid: pid,
      user_id: user_id
    })

    {:ok, socket}
  end

  def handle_info(:new_message, socket) do
    push(socket, "new_chat_message", %{})
    {:noreply, socket}
  end
end

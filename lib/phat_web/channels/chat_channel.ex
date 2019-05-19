defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel
  alias PhatWeb.Presence

  def join("event_bus:" <> chat_id, _message, socket) do
    pid = :erlang.term_to_binary(self()) |> :base64.encode()
    Presence.track(self(), "event_bus:#{chat_id}", pid, %{
      channel_pid: pid
    })

    {:ok, socket}
  end

  def handle_info(:new_message, socket) do
    push(socket, "new_chat_message", %{})
    {:noreply, socket}
  end
end

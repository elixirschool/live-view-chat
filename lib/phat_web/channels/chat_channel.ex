defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel
  alias PhatWeb.Presence

  def join("event_bus:" <> chat_id, _message, socket) do
    IO.puts("JOINING...")
    pid = :erlang.term_to_binary(self()) |> :base64.encode()
    Presence.track(self(), "event_bus:#{chat_id}", pid, %{
      channel_pid: pid
    })

    {:ok, socket}
  end

  def handle_info({:new_message, %{current_user_id: _current_user_id}}, socket) do
    push(socket, "new_chat_message", %{})
    # if current_user_id == socket.assigns.current_user_id do
    #   IO.puts("MATCHING USER #{current_user_id}")
    # end

    {:noreply, socket}
  end
end

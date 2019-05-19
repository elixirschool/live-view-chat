defmodule PhatWeb.ChatChannel do
  use Phoenix.Channel

  def join("event_bus:" <> _chat_id, _message, socket) do
    IO.puts "JOINING..."
    {:ok, socket}
  end
end

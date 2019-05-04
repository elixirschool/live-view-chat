defmodule PhatWeb.ChatLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <%= @chat.room_name %>
      </div>
    </div>
    """
  end

  def mount(session, socket) do
    {:ok, assign(socket, chat: session.chat)}
  end
end

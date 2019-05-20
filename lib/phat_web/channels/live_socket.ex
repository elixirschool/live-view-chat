defmodule PhatWeb.LiveSocket do
  @moduledoc """
  The LiveView socket for Phoenix Endpoints.
  """
  use Phoenix.Socket

  defstruct id: nil,
            endpoint: nil,
            parent_pid: nil,
            assigns: %{},
            changed: %{},
            fingerprints: {nil, %{}},
            private: %{},
            stopped: nil,
            connected?: false

  channel "lv:*", Phoenix.LiveView.Channel
  channel "event_bus:*", PhatWeb.ChatChannel

  @doc """
  Connects the Phoenix.Socket for a LiveView client.
  """
  @impl Phoenix.Socket
  def connect(params, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user salt", params["channel_token"], max_age: 86400) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user_id, user_id)
        {:ok, socket}

      {:error, _} ->
        :error
    end
  end

  @doc """
  Identifies the Phoenix.Socket for a LiveView client.
  """
  @impl Phoenix.Socket
  def id(_socket), do: nil
end

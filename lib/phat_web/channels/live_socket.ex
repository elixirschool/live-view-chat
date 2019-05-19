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
  def connect(params, %Phoenix.Socket{} = socket, _connect_info) do
    {:ok, assign(socket, :current_user_id, String.to_integer(params["user_id"]))}
  end

  @doc """
  Identifies the Phoenix.Socket for a LiveView client.
  """
  @impl Phoenix.Socket
  def id(_socket), do: nil
end

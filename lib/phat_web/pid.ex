defmodule PhatWeb.Pid do
  def from_binary(binary) do
    binary
    |> :base64.decode()
    |> :erlang.binary_to_term()
  end

  def to_binary(pid) do
    pid
    |> :erlang.term_to_binary()
    |> :base64.encode()
  end
end

defmodule Phat.SessionRegistrySupervisor do
  use Supervisor

def start_link do
  Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
end

def init(:ok) do
  # Registry.start_link(keys: :unique, name: Registry.UniqueCountTest)
  children = [
    worker(Registry, [keys: :unique, name: Registry.SessionRegistry])
  ]

  supervise(children, strategy: :one_for_one)
end
end

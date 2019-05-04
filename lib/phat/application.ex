defmodule Phat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Phat.Repo,
      # Start the endpoint when the application starts
      PhatWeb.Endpoint,
      PhatWeb.Presence
      # Starts a worker by calling: Phat.Worker.start_link(arg)
      # {Phat.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

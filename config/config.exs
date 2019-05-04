# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phat,
  ecto_repos: [Phat.Repo]

# Configures the endpoint
config :phat, PhatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YsCaRB0LDVBAErKSsCeFV+mHfxbbzGhOBVVW+IkBYKXIfYA7enKk/rmsiTKodxqL",
  render_errors: [view: PhatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phat.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "EWF2aYSGeG6xS7W4taCCOO070F4oe4cnVG4x4t+fIZC5cRISMnwK3vdFeG5tFBbb"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

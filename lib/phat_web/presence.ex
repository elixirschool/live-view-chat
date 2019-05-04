defmodule PhatWeb.Presence do
  use Phoenix.Presence,
    otp_app: :phat,
    pubsub_server: Phat.PubSub
end

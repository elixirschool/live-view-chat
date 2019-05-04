defmodule Phat.Repo do
  use Ecto.Repo,
    otp_app: :phat,
    adapter: Ecto.Adapters.Postgres
end

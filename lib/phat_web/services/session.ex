defmodule PhatWeb.Services.Session do
  alias Phat.Repo
  alias Phat.Accounts.User

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        :error

      user ->
        case verify_password(password, user.encrypted_password) do
          true ->
            {:ok, user}

          _ ->
            :error
        end
    end
  end

  defp verify_password(password, pw_hash) do
    Comeonin.Bcrypt.checkpw(password, pw_hash)
  end
end

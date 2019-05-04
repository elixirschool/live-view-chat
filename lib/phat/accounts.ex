defmodule Phat.Accounts do
  alias Phat.Repo
  alias Phat.Accounts.User

  def change_user(changeset) do
    User.changeset(changeset)
  end

  def list_users do
    Repo.all(User)
  end

  def create_user(user_params) do
    User.changeset(%User{}, user_params)
    |> Repo.insert()
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
  end
end

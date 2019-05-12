# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Phat.Repo.insert!(%Phat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Phat.Chats.Chat
alias Phat.Chats.Message
alias Phat.Accounts.User
alias Phat.Repo

changeset = User.changeset(%User{}, %{first_name: "Jim", last_name: "Smith", email: "jim@email.com", password: "password"})
jim = Repo.insert!(changeset)
changeset = User.changeset(%User{}, %{first_name: "Alice", last_name: "Johnson", email: "alice@email.com", password: "password"})
alice = Repo.insert!(changeset)

chat = Repo.insert!(%Chat{room_name: "Jim's Workspace"})

Repo.insert!(%Message{chat_id: chat.id, user_id: jim.id, content: "Good morning!"})
Repo.insert!(%Message{chat_id: chat.id, user_id: alice.id, content: "Hi!"})
Repo.insert!(%Message{chat_id: chat.id, user_id: jim.id, content: "What's new?"})
Repo.insert!(%Message{chat_id: chat.id, user_id: alice.id, content: "Not much, how are you?"})
Repo.insert!(%Message{chat_id: chat.id, user_id: jim.id, content: "Good!"})

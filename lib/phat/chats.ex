defmodule Phat.Chats do
  alias Phat.Repo
  alias Phat.Chats.Chat
  alias Phat.Chats.Message
  import Ecto.Query

  def create_chat(chat_params) do
    Chat.changeset(%Chat{}, chat_params)
    |> Repo.insert
  end

  def create_message(message_params) do
    Message.changeset(%Message{}, message_params)
    |> Repo.insert
  end

  def list_chats do
    Repo.all(Chat)
  end

  def get_chat(chat_id) do
    query = from c in Chat,
      where: c.id == ^chat_id,
      preload: [:messages]

    Repo.one(query)
  end
end

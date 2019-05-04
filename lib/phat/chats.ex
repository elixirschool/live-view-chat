defmodule Phat.Chats do
  alias Phat.Repo
  alias Phat.Chats.Chat
  alias Phat.Chats.Message
  import Ecto.Query

  def create_chat(chat_params) do
    Chat.changeset(%Chat{}, chat_params)
    |> Repo.insert()
  end

  def create_message(chat, message_params) do
    message_params =
      message_params
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      |> Map.put(:user_id, String.to_integer(message_params["user_id"]))

    message = Ecto.build_assoc(chat, :messages, message_params)
    messages = Enum.reverse([message | chat.messages])

    chat =
      Ecto.Changeset.change(chat)
      |> Ecto.Changeset.put_assoc(:messages, messages)
      |> Repo.update!()

    Phat.Chats.get_chat(chat.id)
  end

  def change_message(changeset \\ %Message{}) do
    Message.changeset(changeset)
  end

  def list_chats do
    Repo.all(Chat)
  end

  def get_chat(chat_id) do
    query =
      from c in Chat,
        where: c.id == ^chat_id,
        preload: [messages: :user]

    Repo.one(query)
  end
end

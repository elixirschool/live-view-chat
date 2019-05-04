defmodule Phat.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :chat_id, :integer
      add :content, :text
      add :user_id, :integer

      timestamps()
    end
  end
end

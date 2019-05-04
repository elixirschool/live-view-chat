defmodule Phat.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phat.Chats.Message

  schema "chats" do
    has_many :messages, Message
    field :room_name, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room_name])
    |> validate_required([:room_name])
  end
end

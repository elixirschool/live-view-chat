defmodule PhatWeb.ChatView do
  use PhatWeb, :view

  def username_color(user, username_colors) do
    {_email, color} =
      Enum.find(username_colors, fn {email, _color} ->
        email == user.email
      end)

    color
  end

  def font_weight(user, current_user) do
    if user.email == current_user.email do
      "bold"
    else
      "normal"
    end
  end

  def elipses(true), do: "..."
  def elipses(false), do: nil
end

defmodule PhatWeb.PageController do
  use PhatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule Tudo.PageController do
  use Tudo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

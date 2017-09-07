defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.IssueController
  alias Tudo.{Issue, Repo}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def index(conn, params) do
    {query, rummage} = Issue
      |> Ecto.rummage(params["rummage"])

    issues = Repo.all(query)

    render conn,
      "index.html",
      issues: issues,
      current_user: get_session(conn, :current_user),
      rummage: rummage
  end
end

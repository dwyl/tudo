defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.IssueController

  def index(conn, _params) do
    redirect conn, to: "/1"
  end

  def show(conn, %{"id" => page_number}) do

    issues = IssueController.getIssues page_number

    render conn, "index.html", current_user: get_session(conn, :current_user), issues: issues
  end
end

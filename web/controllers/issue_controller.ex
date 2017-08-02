defmodule Tudo.IssueController do
  use Tudo.Web, :controller
  use Rummage.Phoenix.Controller

  alias Tudo.{Issue, Repo}

  def get_issues(params) do
    {query, rummage} = Issue
      |> Issue.rummage(params["rummage"])

    issues = Repo.all(query)
    %{issues: issues, rummage: rummage}
    # render conn,
    #   "index.html",
    #   issues: issues,
    #   rummage: rummage
    # IO.puts "issue controller ----" <> id
    # query = from i in Issue,
    #         limit: 10
    # #
    # Repo.all(query)
  end

  def get_issue_count() do
    query = from i in Issue,
            select: count(i.id)

    Repo.all(query)
  end
end

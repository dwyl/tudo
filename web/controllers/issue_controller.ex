defmodule Tudo.IssueController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo}

  def get_issues(id) do
    IO.puts "issue controller ----" <> id
    query = from i in Issue,
            limit: 10
    #
    Repo.all(query)
  end

  def get_issue_count() do
    query = from i in Issue,
            select: count(i.id)

    Repo.all(query)
  end
end

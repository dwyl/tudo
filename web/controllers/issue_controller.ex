defmodule Tudo.IssueController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo}

  def getIssues(id) do
    IO.puts "issue controller ----" <> id
    query = from i in Issue,
            limit: 10

    Repo.all(query)
  end
end

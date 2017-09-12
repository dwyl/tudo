defmodule Tudo.UnlabelledController do
  use Tudo.Web, :controller
  alias Tudo.{IssueNoLabels, Repo}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def index(conn, params) do

    {issues, rummage} =
      case params do
        %{"rummage" => rummage_param, "search" => search_term} ->
          get_issues_no_labels(rummage_param, search_term)
        _ ->
          get_issues_no_labels(params["rummage"])
      end

    render conn,
      "index.html",
      issues: issues,
      current_user: get_session(conn, :current_user),
      rummage: rummage,
      changeset: IssueNoLabels.changeset(%IssueNoLabels{}),
      repos: get_repos()
  end

  def search(conn, %{"issue_no_labels" => %{"repo_name" => search_term}}) do
    redirect(conn, to: unlabelled_path(conn, :index, search: search_term))
  end

  defp get_issues_no_labels(rummage_param) do
    {query, rummage} = IssueNoLabels
      |> Ecto.rummage(rummage_param)

    issues = Repo.all(query)
    {issues, rummage}
  end

  defp get_issues_no_labels(rummage_param, search_term) do
    rummage_param
    |> Map.put(
        "search",
        %{"repo_name" => %{"assoc" => [],
                           "search_term" => search_term,
                           "search_type" => "ilike"}})
    |> get_issues_no_labels
  end

  defp get_repos do
    repo_query = from x in IssueNoLabels,
                 distinct: true,
                 select: x.repo_name
    repo_query
    |> Repo.all
    |> Enum.sort
  end

end

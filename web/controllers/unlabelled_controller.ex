defmodule Tudo.UnlabelledController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo, IssueSorting}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def index(conn, params) do
    initial_rummage = IssueSorting.default_sort_by(params["rummage"])

    {issues, rummage} =
      case params do
        %{"rummage" => _rummage, "search" => search_term} ->
          get_issues_no_labels(initial_rummage, search_term)
        _ ->
          get_issues_no_labels(initial_rummage)
      end

    render conn,
      "index.html",
      issues: issues,
      current_user: get_session(conn, :current_user),
      rummage: rummage,
      changeset: Issue.changeset(%Issue{}),
      repos: get_repos()
  end

  def search(conn, %{"issue" => %{"repo_name" => search_term}}) do
    redirect(conn, to: unlabelled_path(conn, :index, search: search_term))
  end

  defp get_issues_no_labels(rummage_param) do
    rummage_param =
      rummage_param || %{"paginate" => %{}, "search" => %{}, "sort" => %{}}

    rummaging =
      rummage_param
      |> Map.put(
      "search",
      Map.merge(rummage_param["search"], %{"labels" => %{"assoc" => [],
                      "search_term" => [""],
                      "search_type" => "lt"}})
                )

    {query, rummage} = Issue
      |> Ecto.rummage(rummaging)

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
    repo_query = from x in Issue,
                 distinct: true,
                 select: x.repo_name
    repo_query
    |> Repo.all
    |> Enum.sort
  end

end

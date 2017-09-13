defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def index(conn, params) do

    {issues, rummage} =
      case params do
        %{"rummage" => rummage_param, "search" => search_term} ->
          get_issues(rummage_param, search_term)
        _ ->
          get_issues(params["rummage"])
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
    redirect(conn, to: page_path(conn, :index, search: search_term))
  end

  # defp get_issues(rummage_param) do
  #   {query, rummage} = Issue
  #     |> Ecto.rummage(rummage_param)
  #
  #   {Repo.all(query), rummage}
  # end

  defp get_issues(rummage_param) do
    rummage_param =
      rummage_param || %{"paginate" => %{}, "search" => %{}, "sort" => %{}}

    rummaging =
      rummage_param
      |> Map.put(
      "search",
      Map.merge(rummage_param["search"], %{"labels" => %{"assoc" => [],
                      "search_term" => [""],
                      "search_type" => "gt"}})
                )

    {query, rummage} = Issue
      |> Ecto.rummage(rummaging)

    issues = Repo.all(query)
    {issues, rummage}
  end

  defp get_issues(rummage_param, search_term) do
    rummage_param
    |> Map.put(
        "search",
        %{"repo_name" => %{"assoc" => [],
                           "search_term" => search_term,
                           "search_type" => "ilike"}})
    |> get_issues
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

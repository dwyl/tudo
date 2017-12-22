defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo, IssueSorting}
  alias Ecto.Date
  use Rummage.Phoenix.Controller

  def index(conn, params) do

    {search_params, initial_rummage} =
      get_db_query_params(
       conn.query_params["rummage"]["store"],
       params["search"],
       params["rummage"]
      )

    {issues, rummage} =
      IssueSorting.collect_issues(search_params, initial_rummage)

    rummage = IssueSorting.default_sort_by(rummage)

    # Sorted list when the page initially loads
    # Fix for: https://github.com/dwyl/tudo/issues/260
    issues = sort_issues_by_gh_updated_at issues

    render conn,
      "index.html",
      issues: issues,
      current_user: get_session(conn, :current_user),
      rummage: rummage,
      changeset: Issue.changeset(%Issue{}),
      repos: get_repos()
  end

  def sort_issues_by_gh_updated_at(issues) do
    Enum.sort issues, fn %{gh_updated_at: d1}, %{gh_updated_at: d2} ->
      Date.compare(d1, d2) == :gt
    end
  end

  def search(conn, %{"issue" => search_params}) do
    redirect(conn, to: page_path(conn, :index, search: search_params))
  end

  defp get_db_query_params(store, search, rummage) do
    search_params =
    build_search_params(store, search)

    initial_rummage =
      build_initial_rummage_params(rummage, search_params)

    {search_params, initial_rummage}
  end

  defp build_initial_rummage_params(%{"sort" => %{"field" => _field}} = rummage,
                                    _search), do: rummage

  defp build_initial_rummage_params(rummage, %{"sort_by" => sort_by}) do
    Map.put rummage, "sort", %{"field" => sort_by}
  end

  defp build_initial_rummage_params(rummage, _), do: rummage

  defp build_search_params(store, search) do
    params =
      cond do
        store && search ->
          Map.merge store, search
        store || search ->
          store || search
        true ->
          nil
      end

    params && Map.put_new(params, "repo_name", "")
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

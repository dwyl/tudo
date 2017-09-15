defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo, IssueSorting}
  use Rummage.Phoenix.Controller

  def index(conn, params) do
    search_params =
    build_search_params(conn.query_params["rummage"]["store"], params["search"])

    initial_rummage =
      build_initial_rummage_params(params["rummage"], search_params)

    {issues, rummage} =
      case search_params do
        nil ->
          IssueSorting.get_issues(initial_rummage)
        search_params ->
          case IssueSorting.labels_to_search(search_params) do
            [] ->
              IssueSorting.get_issues(initial_rummage, search_params)
            labels ->
              IssueSorting.get_issues_by_labels(initial_rummage,
                                                search_params,
                                                labels)
          end
      end

    rummage =
      if Map.get(rummage["sort"], "field") do
        rummage
      else
        rummage
        |> Map.put("sort", %{"field" => "gh_updated_at.desc"})
      end

    render conn,
      "index.html",
      issues: issues,
      current_user: get_session(conn, :current_user),
      rummage: rummage,
      changeset: Issue.changeset(%Issue{}),
      repos: get_repos()
  end

  def search(conn, %{"issue" => search_params}) do
    redirect(conn, to: page_path(conn, :index, search: search_params))
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

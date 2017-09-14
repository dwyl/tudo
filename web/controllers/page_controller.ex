defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo, IssueSorting}
  use Rummage.Phoenix.Controller

  def index(conn, params) do
    {issues, rummage} =
      case params do
        %{"rummage" => rummage_param, "search" => search_params} ->
          case IssueSorting.labels_to_search(params["search"]) do
            [] ->
              IssueSorting.get_issues(rummage_param, search_params)
            labels ->
              IssueSorting.get_issues_by_labels(rummage_param,
                                                search_params,
                                                labels)
          end
        _ ->
          case conn.query_params["rummage"]["store"] do
            nil ->
              IssueSorting.get_issues(params["rummage"])
            stored_params ->
              IssueSorting.get_issues_by_labels(
                            params["rummage"],
                            stored_params,
                            IssueSorting.labels_to_search(stored_params))
          end
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

  defp get_repos do
    repo_query = from x in Issue,
                 distinct: true,
                 select: x.repo_name
    repo_query
    |> Repo.all
    |> Enum.sort
  end

end

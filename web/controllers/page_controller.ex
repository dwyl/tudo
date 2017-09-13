defmodule Tudo.PageController do
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def index(conn, params) do
    IO.inspect params
    {issues, rummage} =
      case params do
        %{"rummage" => rummage_param, "search" => search_params} ->
          case labels_to_search(params["search"]) do
            [] ->
              get_issues(rummage_param, search_params)
            labels ->
              get_issues_labels(rummage_param, search_params, labels)
          end
        _ ->
          #@TODO add label search here ?
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

  def search(conn, %{"issue" => search_params}) do
    redirect(conn, to: page_path(conn, :index, search: search_params))
  end

  defp get_issues(rummage_param) do
    {query, rummage} = Issue
      |> Ecto.rummage(rummage_param)

    {Repo.all(query), rummage}
  end

  defp get_issues(rummage_param, search_params) do
    rummage_param
    |> Map.put(
        "search",
        Map.merge(rummage_param["search"], %{"repo_name" => %{"assoc" => [],
                                             "search_term" => search_params["repo_name"],
                                             "search_type" => "ilike"},
                                             })
                           )

    |> get_issues
  end

  def labels_to_search(search_params) do
    search_params
    |> Map.delete("repo_name")
    |> Map.to_list
    |> Enum.filter(fn {_name, bool} ->
      bool == "true"
    end)
    |> Enum.map(fn {name, _bool} ->
      name
    end)
  end

  def get_issues_labels(rummage_params, search_params, labels) do
    IO.puts "HAPPENING BLAAAAAAAAAAAAAAAAAH"
    IO.puts(labels)
      {_query, rummage} = Issue
      |> Ecto.rummage(rummage_params)

      query =
        case search_params["repo_name"] do
          "" ->
            from x in Issue
          search ->
            from x in Issue,
            where: ilike x.repo_name, ^search
        end

      issues_all = Repo.all(query)
      |> filter_issues_by_labels(labels)

      rummage = construct_rummage(issues_all, rummage)
      |> Map.put(
          "search",
          Map.merge(rummage_params["search"], %{"repo_name" => %{"assoc" => [],
                                               "search_term" => search_params["repo_name"],
                                               "search_type" => "ilike"},
                                               })
                             )
      |> Map.put("store", search_params)

      IO.inspect rummage

      issues = limit_issues_per_page(issues_all, rummage)

      {issues, rummage}
  end

  def limit_issues_per_page(issues, %{"paginate" => %{"max_page" => max_page, "page" => page, "per_page" => per_page,
    "total_count" => total_count}}) do
    Enum.slice(issues, String.to_integer(per_page) * (String.to_integer(page) - 1), String.to_integer(per_page))
  end

  def construct_issues_and_rummage({issues, rummage}, labels_to_search_for) do
    new_issues = filter_issues_by_labels(issues, labels_to_search_for)
    new_rummage = construct_rummage(new_issues, rummage)

    {new_issues, new_rummage}
  end

  def filter_issues_by_labels(list_of_issues, labels_to_search_for) do
    # list of issues
    # |> filter ( %{label} ->  mapped_labels = (label.map split ; [1]) mapped_labels contains_all label_options )
    list_of_issues
    |> Enum.filter(fn %Tudo.Issue{labels: labels} ->
      contains_all_labels?(labels, labels_to_search_for)
    end)
  end

  def construct_rummage(list_of_issues, rummage) do
    # %{"paginate" => %{"max_page" => "54", "page" => "1", "per_page" => "20",
    # "total_count" => "1065"}, "search" => %{}, "sort" => %{}}
    total_count = length(list_of_issues)
    max_page = get_page_count(total_count)

    Map.put(
      rummage,
      "paginate",
      Map.merge(rummage["paginate"], %{
          "total_count" => total_count |> Integer.to_string,
          "max_page" => max_page |> Integer.to_string
          })
    )


  end

  defp get_page_count(number_of_issues) do
    innacurate_page_number = div(number_of_issues, 20)
    case rem(number_of_issues, 20) do
      0 ->
        innacurate_page_number
      _ ->
        innacurate_page_number + 1
    end

  end

  defp contains_all_labels?(label_list, labels_to_search_for) do
    only_label_name_list =
      label_list
      |> Enum.map(fn label ->
        [_head | label_name] = String.split(label, ";")
        label_name
      end)
      |> List.flatten

    Enum.all?(labels_to_search_for, fn label_name ->
      Enum.member?(only_label_name_list, label_name)
    end)

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

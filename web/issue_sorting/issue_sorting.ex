defmodule Tudo.IssueSorting do
  @moduledoc"""
  Provides an api for listing, searching and sorting issues stored in the
  database
  """
  use Tudo.Web, :controller
  alias Tudo.{Issue, Repo}
  alias Rummage.Ecto
  use Rummage.Phoenix.Controller

  def get_issues(rummage_param) do
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

  def get_issues(rummage_param, search_params) do
    rummage_param
    |> Map.put(
        "search",
        Map.merge(rummage_param["search"],
          %{"repo_name" => %{"assoc" => [],
                             "search_term" => search_params["repo_name"],
                             "search_type" => "ilike"},
                            }))
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

  def get_issues_by_labels(rummage_params, search_params, labels) do
      {_query, rummage} = Issue
      |> Ecto.rummage(rummage_params)

      [sort, direction] =
        case rummage["sort"]["field"] do
          nil ->
            [:gh_updated_at, :desc]
          field ->
            field
            |> String.split(".")
            |> Enum.map(&(String.to_atom(&1)))
        end

      query =
        case search_params["repo_name"] do
          "" ->
            from x in Issue,
            [order_by: ^[{direction, sort}]]
          search ->
            from x in Issue,
            [where: ilike(x.repo_name, ^search),
            order_by: ^[{direction, sort}]]
        end

      query
      |> Repo.all
      |> filter_issues_by_labels(labels)
      |> construct_issues_and_rummage(rummage, search_params)
  end

  defp construct_issues_and_rummage(all_issues, rummage, search_params) do
    rummage = construct_rummage(all_issues, rummage, search_params)
    issues = paginate_issues(rummage, all_issues)

    {issues, rummage}
  end

  defp paginate_issues(%{"paginate" => %{"max_page" => _max_page,
                                        "page" => page,
                                        "per_page" => per_page,
                                        "total_count" => _total_count}},
                                        issues) do

    start_number = String.to_integer(per_page) * (String.to_integer(page) - 1)

    Enum.slice(issues, start_number, String.to_integer(per_page))
  end

  defp filter_issues_by_labels(list_of_issues, labels_to_search_for) do
    list_of_issues
    |> Enum.filter(fn %Tudo.Issue{labels: labels} ->
      contains_all_labels?(labels, labels_to_search_for)
    end)
  end

  defp construct_rummage(list_of_issues, rummage, search_params) do
    total_count = length(list_of_issues)
    max_page = get_page_count(total_count)

    rummage
    |> Map.put(
      "paginate",
      Map.merge(rummage["paginate"], %{
        "total_count" => total_count |> Integer.to_string,
        "max_page" => max_page |> Integer.to_string
      }))
    |> Map.put(
        "search",
        Map.merge(rummage["search"], %{
           "repo_name" => %{"assoc" => [],
           "search_term" => search_params["repo_name"],
           "search_type" => "ilike"},
        }))
    |> Map.put("store", search_params)
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
        [_head | [label_name]] = String.split(label, ";")
        label_name
      end)

    Enum.all?(labels_to_search_for, fn label_name ->
      Enum.member?(only_label_name_list, label_name)
    end)
  end

  def collect_issues(search_params, initial_rummage) do
    case search_params do
      nil ->
        get_issues(initial_rummage)
      search_params ->
        case labels_to_search(search_params) do
          [] ->
            get_issues(initial_rummage, search_params)
          labels ->
            get_issues_by_labels(initial_rummage,
                                 search_params,
                                 labels)
        end
    end
  end

  def default_sort_by(rummage) do
      if Map.get(rummage["sort"], "field") do
        rummage
      else
        rummage
        |> Map.put("sort", %{"field" => "gh_updated_at.desc"})
      end
  end

end

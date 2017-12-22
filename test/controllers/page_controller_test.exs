defmodule Tudo.PageControllerTest do
  use Tudo.ConnCase
  doctest Tudo.PageController, import: true

  alias Tudo.PageController
  alias Ecto.Date

  test "GET /", %{conn: conn} do
    conn = get(conn, "/", %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}})
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / with params", %{conn: conn} do
    params =
      %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}},
        "search" => %{"repo_name" => "time"}}

    conn = get conn, "/", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET /search", %{conn: conn} do
    conn = get(conn, "/search", %{"issue" => %{"repo_name" => "hello"}})
    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET / with just label filtering", %{conn: conn} do
    params =
    %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}},
    "search" => %{"discuss" => "true", "repo_name" => "", "starter" => "false"}}

    conn = get conn, "/", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / with label filtering and sort_by", %{conn: conn} do
    params =
    %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}},
    "search" => %{"discuss" => "true", "repo_name" => "", "starter" => "false",
    "sort_by" => "gh_updated_at.desc"}}

    conn = get conn, "/", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / with label filtering dynamically generated", %{conn: conn} do
    params =
    %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}}}

    query_params =
      %{"rummage" => %{"paginate" => %{"page" => "1", "per_page" => "20"},
          "search" => %{"repo_name" => %{"search_term" => "",
              "search_type" => "ilike"}},
          "store" => %{"awaiting-review" => "false", "discuss" => "true",
            "enhancement" => "false", "priority-1" => "false",
            "priority-2" => "false", "priority-3" => "false", "priority-4" => "false",
            "priority-5" => "false", "question" => "false", "repo_name" => "",
            "starter" => "false"}}}

    conn =
      conn
      |> Map.put(:query_params, query_params)
      |> get("/", params)

    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / dynamically generated search with params", %{conn: conn} do
    params =
    %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{"field" => "repo_name.desc"}},
    "search" => %{"discuss" => "true", "repo_name" => "",
                  "sort_by" => "gh_updated_at.desc"}}

    query_params =
      %{"rummage" => %{"paginate" => %{"page" => "1", "per_page" => "20"},
          "search" => %{"repo_name" => %{"search_term" => "",
              "search_type" => "ilike"}},
          "store" => %{"discuss" => "true", "repo_name" => ""}}}

    conn =
      conn
      |> Map.put(:query_params, query_params)
      |> get("/", params)

    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "sort_issues_by_gh_updated_at" do
    erl_dates = [{2016, 12, 1}, {2015, 11, 4}, {2017, 5, 3}]

    unordered_issues = Enum.map erl_dates, &(%{gh_updated_at: Date.from_erl &1})

    sorted_issues = PageController.sort_issues_by_gh_updated_at unordered_issues

    actual = Enum.map sorted_issues, &(Date.to_erl &1.gh_updated_at)
    expected = Enum.sort erl_dates, &(&1 > &2)

    assert actual == expected
  end
end

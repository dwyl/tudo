defmodule Tudo.PageControllerTest do
  use Tudo.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/", %{"rummage" => %{"paginate" => %{},"search" => %{},"sort" => %{}}})
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / with params", %{conn: conn} do
    params =
      %{"rummage" => %{ "paginate" => %{}, "search" => %{}, "sort" => %{} },
        "search" => %{"repo_name" => "time"} }

    conn = get conn, "/", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET /search", %{conn: conn} do
    conn = get(conn, "/search", %{"issue" => %{"repo_name" => "hello"}} )
    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET / with just label filtering", %{conn: conn} do
    params =
    %{"rummage" => %{"paginate" => %{}, "search" => %{}, "sort" => %{}},
    "search" => %{"discuss" => "true", "repo_name" => "", "starter" => "false"}}

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

end

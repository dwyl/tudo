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

  test "POST /", %{conn: conn} do
    conn = get(conn, "/search", %{"issue" => %{"repo_name" => "hello"}} )
    assert html_response(conn, 302) =~ "redirected"
  end

end

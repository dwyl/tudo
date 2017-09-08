defmodule Tudo.PageControllerTest do
  use Tudo.ConnCase

  test "GET /", %{conn: conn} do
    get conn, "/"

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET / with params", %{conn: conn} do
    params =
      %{"rummage" => %{ "paginate" => %{}, "search" => %{}, "sort" => %{} },
        "search" => "time" }

    conn = get conn, "/", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "POST /", %{conn: conn} do
    conn = post(conn, "/", %{"issue" => %{"repo_name" => "hello"}} )
    assert html_response(conn, 302) =~ "redirected"
  end

end

defmodule Tudo.UnlabelledControllerTest do
  use Tudo.ConnCase

  test "GET /labels", %{conn: conn} do
    conn = get(conn, "/labels", %{"rummage" => %{"paginate" => %{},"search" => %{},"sort" => %{}}})
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET /labels with params", %{conn: conn} do
    params =
      %{"rummage" => %{ "paginate" => %{}, "search" => %{}, "sort" => %{} },
        "search" => "time" }

    conn = get conn, "/labels", params
    assert html_response(conn, 200) =~ "Help Wanted"
  end

  test "GET /labels/search", %{conn: conn} do
    conn = get(conn, "/labels/search", %{"issue_no_labels" => %{"repo_name" => "hello"}} )
    assert html_response(conn, 302) =~ "redirected"
  end

end

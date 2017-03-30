defmodule Tudo.AuthControllerTest do
  use Tudo.ConnCase

  alias Ueberauth.Auth

  test "GET /auth/github/callback", %{conn: conn} do
    conn = put_in(conn.assigns, %{ueberauth_auth: %Auth{}})
    conn = get conn, "/auth/github/callback"

    assert html_response(conn, 302) =~ "redirected"
    assert get_flash(conn, :info) =~ "sucessfully authenticated"
  end

  test "GET /auth/github/callback with errors", %{conn: conn} do
    conn = get conn, "/auth/github/callback"

    assert html_response(conn, 302) =~ "redirected"
    assert get_flash(conn, :info) =~ "error while authenticating"
  end

end

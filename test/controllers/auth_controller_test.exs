defmodule Tudo.AuthControllerTest do
  use Tudo.ConnCase

  alias Ueberauth.Auth

  test "GET /auth/github/callback", %{conn: conn} do
    conn = put_in(conn.assigns, %{ueberauth_auth: %Auth{}})
    conn = get conn, "/auth/github/callback"

    assert html_response(conn, 302) =~ "redirected"
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) =~ "sucessfully authenticated"
  end

  test "GET /auth/github/callback with errors", %{conn: conn} do
    conn = get conn, "/auth/github/callback"

    assert html_response(conn, 302) =~ "redirected"
    assert get_flash(conn, :info) =~ "error while authenticating"
  end

  test "DELETE /auth/logout", %{conn: conn} do
    conn = put_in(conn.assigns, %{ueberauth_auth: %Auth{}})
    conn = get conn, "/auth/github/callback"
    conn = delete conn, "/auth/logout"

    assert get_flash(conn, :info) =~ "logged out"
    assert html_response(conn, 302) =~ "redirected"
    assert conn.private[:plug_session_info] == :drop
  end
end

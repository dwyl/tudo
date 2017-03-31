defmodule Tudo.AuthController do
  use Tudo.Web, :controller

  alias Tudo.UserFromAuth

  plug Ueberauth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = UserFromAuth.basic_info(auth)

    conn
    |> put_flash(:info, "sucessfully authenticated.")
    |> put_session(:current_user, user)
    |> redirect(to: "/issues")
  end

  def callback(%{assigns: %{ueberauth_failure: _errors}} = conn, _params) do
    conn
    |> put_flash(:info, "error while authenticating.")
    |> redirect(to: "/")
  end
end

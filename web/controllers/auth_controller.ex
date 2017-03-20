defmodule Tudo.AuthController do
  use Tudo.Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: _auth}} = conn, _params) do
    conn
    |> put_flash(:info, "sucessfully authenticated.")
    |> redirect(to: "/")
  end
  
  def callback(%{assigns: %{ueberauth_failure: _errors}} = conn, _params) do
    conn
    |> put_flash(:info, "error while authenticating.")
    |> redirect(to: "/")
  end
end

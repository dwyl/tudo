defmodule Tudo.AuthController do
  use Tudo.Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    conn
    |> put_flash(:info, "sucessfully authenticated.")
    |> redirect(to: "/")
  end
end

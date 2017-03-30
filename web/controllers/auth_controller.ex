defmodule Tudo.AuthController do
  use Tudo.Web, :controller
  plug Ueberauth

  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = basic_info(auth)

    conn
    |> put_flash(:info, "sucessfully authenticated.")
    |> put_session(:current_user, user)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _errors}} = conn, _params) do
    conn
    |> put_flash(:info, "error while authenticating.")
    |> redirect(to: "/")
  end
end

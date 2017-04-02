defmodule Tudo.UserFromAuthTest do
  use Tudo.ModelCase

  alias Ueberauth.Auth
  alias Tudo.UserFromAuth

  test "basic info, with name" do
    name = "eoin"
    id = "eoin's id"
    avatar = "avatar"

    auth = %Auth{uid: id, info: %{name: name, image: avatar}}
    info = UserFromAuth.basic_info auth

    assert info == %{id: id, name: name, avatar: avatar}
  end

  test "basic info, without name" do
    first_name = "eoin"
    last_name = "mc"

    auth = %Auth{info: %{first_name: first_name, last_name: last_name}}
    info = UserFromAuth.basic_info auth

    assert info.name == "eoin mc"
  end
end


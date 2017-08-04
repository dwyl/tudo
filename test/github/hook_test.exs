defmodule Tudo.HookTest do
  use Tudo.ConnCase

  alias Tudo.Hook

  @url "http://myapp.com/api/hooks"

  test "get" do
    actual = Hook.get("dwyl/tudo")
    expected = [%{"name" => "web", "id" => 1, "config" => %{"url" => @url}}]

    assert actual == expected
  end

  test "create" do
    actual = Hook.create("dwyl/tudo", @url)
    expected = [%{"name" => "web", "config" => %{"url" => @url}}]

    assert actual == expected
  end

  test "delete" do
    actual = Hook.delete("dwyl/tudo", @url)
    expected = [%{"message" => "deleted"}]

    assert actual == expected
  end
end

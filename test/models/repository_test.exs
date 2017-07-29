defmodule Tudo.RepositoryTest do
  use Tudo.ModelCase

  alias Tudo.Repository

  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Repository.changeset(%Repository{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Repository.changeset(%Repository{}, @invalid_attrs)
    refute changeset.valid?
  end
end

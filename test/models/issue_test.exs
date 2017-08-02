defmodule Tudo.IssueTest do
  use Tudo.ModelCase

  alias Tudo.Issue

  @valid_attrs %{assignees: [], comments_number: 42, gh_created_at: %{day: 17, month: 4, year: 2010}, gh_updated_at: %{day: 17, month: 4, year: 2010}, labels: [], repo_name: "some content", state: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Issue.changeset(%Issue{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Issue.changeset(%Issue{}, @invalid_attrs)
    refute changeset.valid?
  end
end

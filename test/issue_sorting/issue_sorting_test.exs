defmodule Tudo.IssueSortingTest do
  use Tudo.ConnCase
  # doctest Tudo.IssueSorting, import: true

  alias Tudo.IssueSorting



  @labels_some_true %{"awaiting-review" => "true", "discuss" => "true",
  "enhancement" => "true", "priority-1" => "false", "priority-2" => "false",
  "repo_name" => ""}

  @labels_none_true %{"awaiting-review" => "false", "discuss" => "false",
  "enhancement" => "false", "priority-1" => "false", "priority-2" => "false",
  "repo_name" => ""}

  @issues_to_insert make_issue(1, 5, %{
                               :labels => ["#009800;help wanted",
                                           "na;discuss"],
                               :repo_name => "hello"}) ++
                    make_issue(6, 21, %{
                               :labels => ["#009800;help wanted",
                                           "na;discuss"]}) ++
                    [%{:labels => ["#009800;help wanted", "na;hello"],
                       :title => "Issue 22"}]

  @sort_by_name_and_labels_issues [
    %{:labels => ["#009800;help wanted", "na;discuss"], :title => "Issue 1",
    :repo_name => "bye"},
    %{:labels => ["#009800;help wanted"], :title => "Issue 2",
    :repo_name => "bye"},
    %{:labels => ["#009800;help wanted", "na;discuss"], :title => "Issue 3",
    :repo_name => "bye"},
    %{:labels => ["#009800;help wanted", "na;discuss"], :title => "Issue 4",
    :repo_name => "hello"},
  ]

  @exactly_20_labelled_issues make_issue(1, 20, %{
                               :labels => ["#009800;help wanted",
                                           "na;discuss"]}) ++
                                           [%{:labels => [
                                             "#009800;help wanted"],
                                              :title => "Issue 21"}
                                            ]

  @sort_by_repo_name_and_labels [
    %{:labels => ["#009800;help wanted", "na;discuss"], :title => "Issue 1",
    :repo_name => "a"},
    %{:labels => ["#009800;help wanted", "na;discuss"], :title => "Issue 2",
    :repo_name => "b"},
    %{:labels => ["#009800;help wanted"], :title => "Issue 3",
    :repo_name => "c"},
  ]

  @empty_rummage_params %{"paginate" => %{}, "search" => %{}, "sort" => %{}}
  @page_two_rummage_params %{"paginate" => %{"page" => "2", "per_page" => "20"},
                             "search" => %{},
                             "sort" => %{}}
  @sort_by_repo_name_rummage_params %{"paginate" => %{},
                                      "search" => %{},
                                      "sort" => %{"field" => "repo_name.desc"}}

  test "labels_to_search with some true labels" do
    actual = IssueSorting.labels_to_search @labels_some_true
    expected = ["awaiting-review", "discuss", "enhancement"]

    assert actual == expected
  end

  test "labels_to_search with no true labels" do
    actual = IssueSorting.labels_to_search @labels_none_true
    expected = []

    assert actual == expected
  end

  test "get_issues/1 gets the first 20 issues from the database" do
    insert_issues_from_list @issues_to_insert
    {actual, _} = IssueSorting.get_issues @empty_rummage_params
    expected = 20

    assert length(actual) == expected
  end

  test "get_issues/1 with pagination gets the second page of issues" do
    insert_issues_from_list @issues_to_insert
    {actual, _} = IssueSorting.get_issues @page_two_rummage_params
    expected = 2

    assert length(actual) == expected
  end

  test "get_issues/2 with search_params gets only issues from a repo" do
    insert_issues_from_list @issues_to_insert
    {actual, _} = IssueSorting.get_issues(
                    @empty_rummage_params,
                    %{"repo_name" => "hello"})
    expected = 5

    assert length(actual) == expected
  end

  test "get_issues_by_labels filters issues by labels" do
    insert_issues_from_list @issues_to_insert
    {actual, _} = IssueSorting.get_issues_by_labels(
                    @empty_rummage_params,
                    %{"repo_name" => ""},
                    ["hello"])
    expected = 1

    assert length(actual) == expected
  end

  test "get_issues_by_labels filters issues by labels and paginates" do
    insert_issues_from_list @issues_to_insert
    {actual, _} = IssueSorting.get_issues_by_labels(
                    @page_two_rummage_params,
                    %{"repo_name" => ""},
                    ["discuss"])
    expected = 1

    assert length(actual) == expected
  end

  test "get_issues_by_labels filters issues by labels and repo name" do
    insert_issues_from_list @sort_by_name_and_labels_issues
    {actual, _} = IssueSorting.get_issues_by_labels(
                      @empty_rummage_params,
                      %{"repo_name" => "bye"},
                      ["discuss"])
    expected = 2

    assert length(actual) == expected
  end

  test "get_issues_by_labels works for exactly 20 results" do
    insert_issues_from_list @exactly_20_labelled_issues
    {actual, _} = IssueSorting.get_issues_by_labels(
                    @empty_rummage_params,
                    %{"repo_name" => ""},
                    ["discuss"])
    expected = 20

    assert length(actual) == expected
  end

  test "get_issues_by_labels filters labels while also sort results" do
    insert_issues_from_list @sort_by_repo_name_and_labels
    {actual, _} = IssueSorting.get_issues_by_labels(
                    @sort_by_repo_name_rummage_params,
                    %{"repo_name" => ""},
                    ["discuss"])
    expected = 2

    # get the repo_name of the first result to check sorting worked
    [%{repo_name: repo_name} | _] = actual

    assert repo_name == "b"
    assert length(actual) == expected
  end

end

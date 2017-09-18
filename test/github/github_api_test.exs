defmodule Tudo.GithubApiTest do
  use Tudo.ConnCase, async: true
  doctest Tudo.GithubApi, import: true

  alias Tudo.GithubApi

  test "get!" do
    actual = GithubApi.get! "/"
    expected = %{"method" => "get"}

    assert actual == expected
  end

  test "post!" do
    actual = GithubApi.post! "/", %{key: "val"}
    expected = %{"method" => "post", "key" => "val"}

    assert actual == expected
  end

  test "delete!" do
    actual = GithubApi.delete! "/"
    expected = %{"method" => "delete"}

    assert actual == expected
  end

  test "get_repos :: not multiple of 100 repos" do
    actual = GithubApi.get_repos("dwyl")
    expected_first_4 = ["repo1", "repo2", "repo3", "repo4"]
    expected_length = 255

    assert Enum.take(actual, 4) == expected_first_4
    assert length(actual) == expected_length
  end

  test "get_repos :: multiple of 100 repos" do
    actual = GithubApi.get_repos("200repos")
    expected_first_4 = ["repo1", "repo2", "repo3", "repo4"]
    expected_length = 200

    assert Enum.take(actual, 4) == expected_first_4
    assert length(actual) == expected_length
  end

  test "get_all_issues :: dwyl/tudo" do
    actual = GithubApi.get_all_issues("dwyl/tudo")
    expected = [
      %{"title" => "Issue title",
        "labels" => [%{"name" => "help wanted",
                       "color" => "159818",
                       "default" => true}],
        "state" => "open",
        "html_url" => "https://github.com/dwyl/tudo/issues/1",
        "assignees" => [%{"login" => "shouston3",
                          "avatar_url" => "https://github.com/shouston3"}],
        "comments" => 1,
        "created_at" => "2011-04-22T13:33:48Z",
        "updated_at" => "2011-04-22T13:33:48Z"
      }
    ]

    assert actual == expected
  end

  @avatar_url "https://avatars0.githubusercontent.com/u/15983736?v=4&s=460"
  test "format_data" do
    input = %{"title" => "Issue title",
              "labels" => [%{"name" => "help wanted",
                             "color" => "159818",
                             "default" => true}],
              "state" => "open",
              "html_url" => "https://github.com/dwyl/tudo/issues/1",
              "assignees" => [%{"login" => "shouston3",
                                "avatar_url" => @avatar_url}],
              "comments" => 1,
              "created_at" => "2011-04-22T13:33:48Z",
              "updated_at" => "2011-04-22T13:33:48Z"}
    actual = GithubApi.format_data input
    expected = %{"title" => "Issue title",
                 "labels" => ["#159818;help wanted"],
                 "state" => "open",
                 "url" => "https://github.com/dwyl/tudo/issues/1",
                 "assignees" => ["shouston3;#{@avatar_url}"],
                 "repo_name" => "tudo",
                 "comments_number" => 1,
                 "gh_created_at" => "2011-04-22T13:33:48Z",
                 "gh_updated_at" => "2011-04-22T13:33:48Z"}

    assert actual == expected
  end

  test "decode!" do
    actual = GithubApi.decode! ""
    expected = %{}

    assert actual == expected
  end

  test "help_wanted_or_no_labels?" do
      empty = %{"labels" => []}
      help_wanted = %{"labels" => [%{"name" => "help wanted"}]}
      neither = %{"labels" => [%{"name" => "enhancement"}]}

      assert GithubApi.help_wanted_or_no_labels?(empty) === true
      assert GithubApi.help_wanted_or_no_labels?(help_wanted) === true
      assert GithubApi.help_wanted_or_no_labels?(neither) === false
  end
end

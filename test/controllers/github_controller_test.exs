defmodule Tudo.GithubControllerTest do
  use Tudo.ConnCase

  import Tudo.GithubController

  test "process_url" do
    token = System.get_env "GITHUB_ACCESS_TOKEN"
    assert process_url("/orgs/dwyl/repos?page=1") == "https://api.github.com/orgs/dwyl/repos?page=1&access_token=" <> token <> "&per_page=100"
  end

  test "get_repos" do
    assert length(get_repos([], 1)) == 235
  end

  test "index" do
    assert index(%{}, "") == %{}
  end

end

defmodule Tudo.GithubApi do
  @moduledoc"""
  Provides a Github api request library.
  Takes care of access tokens and the api url root string and request headers.
  Also takes care of json parsing once the body of the request arrives.
  """

  require Poison

  # Following mocking convention outlined here:
  # http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/
  @httpoison Application.get_env :tudo, :httpoison
  @auth_token System.get_env "GITHUB_ACCESS_TOKEN" # personal access token
  @root_url "https://api.github.com"

  def get!(url),
    do: request! "get", url
  def post!(url, body),
    do: request! "post", url, body
  def delete!(url),
    do: request! "delete", url

  defp request!(method, url, body \\ "")
  defp request!(method, url, body) when is_map(body),
    do: request! method, url, Poison.encode!(body)
  defp request!(method, url, body) do
    headers = [{"Authorization", "token #{@auth_token}"}, {"User-agent", ""}]

    method
    |> @httpoison.request!(@root_url <> url, body, headers,
         [connect_timeout: 1_000_000,
          recv_timeout: 1_000_000,
          timeout: 1_000_000])
    |> Map.get(:body, "{}")
    |> decode!
    end

    def decode!(""), do: decode! "{}"
    def decode!(str), do: Poison.decode! str

  @doc"""
  Gets all repos for an org, takes an :org string
  Returns a list of strings
  E.g. get_repos("dwyl") => ["learn-tdd", "tudo", ...]
  """
  def get_repos(org, page \\ 1, repos \\ []) do
    new_repos = "/orgs/#{org}/repos?per_page=100&page=#{page}"
    |> get!
    |> Enum.map(&Map.fetch!(&1, "name"))

    case length(new_repos) < 100 do
      true -> repos ++ new_repos
      _ -> get_repos org, page + 1, repos ++ new_repos
    end
  end

  @doc"""
  Gets all issues for a given :org/:repo, takes a string of the form: :org/:repo
  Retuns a list of maps where each map contains data for one repo issue
  E.g. get_help_wanted_issues("dwyl/tudo") => [%{"state" => "open", ...}, ...]
  """
  def get_help_wanted_issues(orgrepo),
    do: get! "/repos/#{orgrepo}/issues?labels=help%20wanted"

  @doc"""
  Gets all issues for a given :org/:repo, takes a string of the form: :org/:repo
  Retuns a list of maps where each map contains data for one repo issue
  E.g. get_all_issues("dwyl/tudo") => [%{"state" => "open", ...}, ...]
  """
  def get_all_issues(orgrepo),
    do: get! "/repos/#{orgrepo}/issues"

  @doc"""
  Takes in an issue and formats it for our db format
  the returned format should match the Issue model
  See tests for how this is used
  """
  def format_data(%{"title" => title, "labels" => labels, "state" => state,
                    "created_at" => created_at, "updated_at" => updated_at,
                    "html_url" => html_url, "assignees" => assignees,
                    "comments" => comments}) do
    %{"title" => title,
      "state" => state,
      "url" => html_url,
      "comments_number" => comments,
      "repo_name" => get_repo_name(html_url),
      "labels" => Enum.map(labels, &format_label/1),
      "assignees" => Enum.map(assignees, &format_assignees/1),
      "gh_created_at" => created_at,
      "gh_updated_at" => updated_at
    }
  end

  @doc"""
  Takes in an issue and formats it for our db format
  for issues with no labels. The returned format should
  match our IssueNoLabels model
  """
  def format_data(%{"title" => title, "state" => state,
                    "created_at" => created_at, "updated_at" => updated_at,
                    "html_url" => html_url, "assignees" => assignees,
                    "comments" => comments}) do
    %{"title" => title,
      "state" => state,
      "url" => html_url,
      "comments_number" => comments,
      "repo_name" => get_repo_name(html_url),
      "assignees" => Enum.map(assignees, &format_assignees/1),
      "gh_created_at" => created_at,
      "gh_updated_at" => updated_at
    }
  end

  @doc"""
    iex>format_label(%{"name" => "help wanted", "color" => "159818"})
    "#159818;help wanted"
  """
  def format_label(%{"color" => color, "name" => name}),
    do: "##{color};#{name}"
  @doc"""
    iex>format_assignees(%{"login" => "shouston3", "avatar_url" => "https://github.com/shouston3"})
    "shouston3;https://github.com/shouston3"
  """
  def format_assignees(%{"login" => login, "avatar_url" => avatar_url}),
    do: "#{login};#{avatar_url}"
  @doc"""
  Gets the repo name from the html_url
    iex>get_repo_name("https://github.com/dwyl/tudo")
    "tudo"
    iex>get_repo_name("https://github.com/dwyl/tudo/issues")
    "tudo"
  """
  def get_repo_name(html_url) do
    "https://github.com/dwyl/([^\/\s]+)"
    |> Regex.compile!
    |> Regex.run(html_url)
    |> Enum.at(1)
  end

  @doc"""
    Takes in an issue, and returns true if it has no labels
      iex>has_no_labels?(%{"labels" => [1, 2, 3]})
      false
      iex>has_no_labels?(%{"labels" => []})
      true
  """
  def has_no_labels?(%{"labels" => labels}) do
    length(labels) === 0
  end
end

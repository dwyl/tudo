defmodule Tudo.GithubController do
  use Tudo.Web, :controller
  use HTTPoison.Base

  alias Tudo.GithubController

  @access_token System.get_env "GITHUB_ACCESS_TOKEN"

  def process_url(url) do
    "https://api.github.com" <> url <> "?access_token=" <> @access_token
  end

  def index(conn, %{"org" => org}) do
    {:ok, res} = GithubController.get("/orgs/#{org}/repos")

    res.body
    |> parse_json
    |> get_issues

    conn
  end

  defp get_issues(repos) do
    # for each repo go and get the issues
  end

  defp parse_json(body) do
    {:ok, Poison.Parser.parse!(body)}
  end

end

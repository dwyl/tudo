defmodule Tudo.GithubController do
  use Tudo.Web, :controller
  use HTTPoison.Base

  alias Tudo.GithubController

  @endpoint "https://api.github.com"

  def process_url(url) do
    @endpoint <> url <> "?access_token=f39b939ad9af6a984c0cba760e91bfa8143582a3"
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

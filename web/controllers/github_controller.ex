defmodule Tudo.GithubController do
  use Tudo.Web, :controller
  use HTTPoison.Base

  alias Tudo.GithubController
  alias Poison.Parser

  @access_token System.get_env "GITHUB_ACCESS_TOKEN"
  @issue_fields ["title", "labels", "state", "created_at", "updated_at", "url", "assignees", "comments"]

  def process_url(url) do
    "https://api.github.com" <> url <> "&access_token=" <> @access_token <> "&per_page=100"
  end

  def index(conn, _) do
    get_repos([], 1)
    |> get_issues
    |> format_data

    conn
  end

  def get_repos(repos, page_number) do
    {:ok, res} = GithubController.get("/orgs/dwyl/repos?page=" <>  Integer.to_string(page_number))
    res
    |> Map.fetch!(:body)
    |> Parser.parse!
    |> fn body -> repos ++ body end.()
    |> check_pages(page_number)
  end

  defp check_pages(repos, page_number) do
   case rem(length(repos), 100) do
      0 -> get_repos(repos, (page_number + 1))
      _ -> Enum.map(repos, fn(repo) -> repo["name"] end)
   end

  end

  defp get_issues(repos) do
    repos
    |> Enum.take(2)
    |> generate_tasks
    |> Task.yield_many
    |> get_issue_data
    |> Enum.map(fn %{body: body} -> Parser.parse!(body) end)
    |> List.flatten

  end

  defp get_issue_data(repo_issues) do
    repo_issues
    |> Enum.map(fn({_, {:ok, {:ok, issue_res }}}) -> issue_res end)

  end

  defp generate_tasks(repos) do
    Enum.map(repos, fn(repo) ->
      Task.async( fn -> GithubController.get("/repos/dwyl/" <> repo <> "/issues?labels=help%20wanted") end)
    end)
  end

  def format_data(data) do
    data
    |> Enum.map(fn(issue) -> Map.take(issue, @issue_fields) end)
  end
end

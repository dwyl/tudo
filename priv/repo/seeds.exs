# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tudo.Repo.insert!(%Tudo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Tudo.GetGithubData do
  use HTTPoison.Base

  alias Poison.Parser
  alias Tudo.{Repo, Issue}

  @access_token System.get_env "GITHUB_ACCESS_TOKEN"

  def process_url(url) do
    "https://api.github.com" <> url <> "&access_token=" <> @access_token <> "&per_page=100"
  end

  def index do
    get_repos([], 1)
    |> get_issues
    |> format_data
    |> insert_data
  end

  def get_repos(repos, page_number) do
    "/orgs/dwyl/repos?page=" <>  Integer.to_string(page_number)
    |> get!
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
    |> generate_tasks
    |> Task.yield_many
    |> get_issue_data
    |> Enum.map(fn %{body: body} -> Parser.parse!(body) end)
    |> List.flatten

  end

  def get_issue_data(repo_issues) do
    repo_issues
    |> Enum.map(fn({_, {:ok, issue_res }}) -> issue_res end)
  end

  defp generate_tasks(repos) do
    Enum.map(repos, fn(repo) ->
      Task.async( fn -> get!("/repos/dwyl/" <> repo <> "/issues?labels=help%20wanted") end)
    end)
  end

  def format_data(data) do
    issue_fields = ["title", "labels", "state", "created_at",
                   "updated_at", "url", "assignees", "comments"]
    data
    |> Enum.map(fn(issue) -> Map.take(issue, issue_fields) end)
    |> Enum.map(&get_labels/1)
    |> Enum.map(&get_assignees/1)
    |> Enum.map(&rename_fields/1)
    |> Enum.map(&add_repo_name/1)
  end

  def get_labels(issue) do
    formatted_labels = issue["labels"]
    |> Enum.map(fn label -> Map.take(label, ["color", "name"]) end)
    |> Enum.map(fn label -> Enum.join(Map.values(label), ";") end)
    |> Enum.map(fn label -> "#" <> label end)

    Map.merge(issue, %{"labels" => formatted_labels})
  end

  def get_assignees(issue) do
    formatted_assignees = issue["assignees"]
    |> Enum.map(fn assignee -> Map.take(assignee, ["login", "avatar_url"]) end)
    |> Enum.map(fn assignee -> Enum.join(Map.values(assignee), ";") end)

    Map.merge(issue, %{"assignees" => formatted_assignees})
  end

  def rename_fields(issue) do
    gh_created_at = Map.get(issue, "created_at")
    gh_updated_at = Map.get(issue, "updated_at")

    issue
    |> Map.put("gh_created_at", gh_created_at)
    |> Map.delete("created_at")
    |> Map.put("gh_updated_at", gh_updated_at)
    |> Map.delete("updated_at")
  end

  def add_repo_name(issue) do
    issue["url"]
    |> String.split(["https://api.github.com/repos/dwyl/", "/issues"])
    |> Enum.at(1)
    |> fn(repo_name) -> Map.put(issue, "repo_name", repo_name) end.()
  end

  def insert_data(issues) do
    Enum.each(issues, fn %{"assignees" => assignees,
                          "comments" => comments,
                          "gh_created_at" => gh_created_at,
                          "gh_updated_at" => gh_updated_at,
                          "labels" => labels,
                          "repo_name" => repo_name,
                          "state" => state,
                          "title" => title,
                          "url" => url
                          } ->
      attributes = %{
        assignees: assignees,
        comments_number: comments,
        gh_created_at:  gh_created_at,
        gh_updated_at: gh_updated_at,
        labels: labels,
        repo_name: repo_name,
        state: state,
        title: title,
        url: url
      }
      changeset = Issue.changeset(%Issue{}, attributes)
      Repo.insert!(changeset)
    end)
  end
end

Tudo.GetGithubData.index()

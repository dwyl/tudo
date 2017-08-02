defmodule Tudo.Hooks do
  require HTTPoison
  require Poison

  @auth_token System.get_env "TUDO_AUTH_TOKEN"
  @root_url "https://api.github.com"

  @doc"""
  Deletes all webhooks which are pointing at our server
  """
  def delete_all(repo_name, server) do
    headers = [{"Authorization", @auth_token}, {"User-agent", ""}]

    "#{@root_url}/repos/#{repo_name}/hooks"
    |> HTTPoison.get!(headers)
    |> Map.fetch!(:body)
    |> Poison.decode!
    # Take only the hooks that are pointing to our server
    |> Enum.filter(fn %{"config" => %{"url" => url}} -> url == server end)
    |> Enum.map(fn %{"id" => id} ->
      HTTPoison.delete! "#{@root_url}/repos/#{repo_name}/hooks/#{id}", headers
    end)
  end

  @doc"""
  Creates a webhook on a repo_name of format ":org/:repo" E.g. "dwyl/tudo"
  With a server of form `string`, E.g. "http://myapp.com"
  E.g.:
  create("dwyl/tudo", "http://myapp.com")
  """
  def create(repo_name, server) do
    headers = [{"Authorization", @auth_token}, {"User-agent", ""}]
    body = Poison.encode!(%{"name" => "web",
                            "events" => ["issues", "issue_comment"],
                            "active" => true,
                            "config" => %{"url" => server,
                                          "content_type" => "json"}})

    "#{@root_url}/repos/#{repo_name}/hooks" |> HTTPoison.post!(body, headers)
  end

  @doc"""
  Gets all webhooks on a repository, the repository arg has the form:
  ":org/:repo", E.g. "dwyl/tudo"
  """
  def get(repo_name) do
    headers = [{"Authorization", @auth_token}, {"User-agent", ""}]

    "#{@root_url}/repos/#{repo_name}/hooks" |> HTTPoison.get(headers)
  end
end


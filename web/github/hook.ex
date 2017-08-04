defmodule Tudo.Hook do
  @moduledoc"""
  Provides Github Hook library for 
  """

  alias Tudo.GithubApi

  @doc"""
  Gets all webhooks on a repository, the repository arg has the form:
  ":org/:repo"

  E.g.  "dwyl/tudo"
  """
  def get(repo_name),
    do: GithubApi.get! "/repos/#{repo_name}/hooks"

  @doc"""
  Creates a webhook on a repo_name of format ":org/:repo" E.g. "dwyl/tudo"
  With a server of form `string`, E.g. "http://myapp.com/api/hook"

  E.g. create("dwyl/tudo", "http://myapp.com/api/hook")
  """
  def create(repo_name, server) do
    body = %{"name" => "web",
             "events" => ["issues", "issue_comment"],
             "active" => true,
             "config" => %{"url" => server, "content_type" => "json"}}

    GithubApi.post! "/repos/#{repo_name}/hooks", body
  end

  @doc"""
  Deletes all webhooks which are pointing at our server

  E.g. delete("dwyl/tudo", "http://myapp.com/api/hook")
  """
  def delete(repo_name, server) do
    "/repos/#{repo_name}/hooks"
    |> GithubApi.get!
    |> Enum.filter(fn %{"config" => %{"url" => url}} ->
      # Take only the hooks that are pointing to the specified server
      url == server
    end)
    |> Enum.map(fn %{"id" => id} ->
      GithubApi.delete! "/repos/#{repo_name}/hooks/#{id}"
    end)
  end
end

require HTTPoison
require Poison

defmodule Hooks do
  @auth_token System.get_env "TUDO_AUTH_TOKEN"

  def delete_all(repo_name, server) do
    root_url = "https://api.github.com"
    headers = [{"Authorization", @auth_token}, {"User-agent", ""}]

    "#{root_url}/repos/#{repo_name}/hooks"
    |> HTTPoison.get!(headers)
    |> Map.fetch!(:body)
    |> Poison.decode!
    # Take only the hooks that are pointing to our server
    |> Enum.filter(fn %{"config" => %{"url" => url} -> url == server end)
    |> Enum.map(fn %{"id" => id} ->
      HTTPoison.delete! "#{root_url}/repos/#{repo_name}/hooks/#{id}", headers
    end)
  end

  def create(repo_name, server) do
    root_url = "https://api.github.com"
    headers = [{"Authorization", "Basic c2hvdXN0b24zOjk3MzRjYjI4NGQ1MzE5ZjhkNjk5ZmQxMGVhZWZjODRkOTljNGIwOTg="},
                  {"User-agent", ""}]
    body = Poison.encode!(%{"name" => "web",
                            "events" => ["issues"],
                            "active" => true,
                            "config" => %{"url" => server,
                                          "content_type" => "json"}})

    "#{root_url}/repos/#{repo_name}/hooks"
    |> HTTPoison.post!(body, headers)
    |> IO.inspect
  end
end

Hooks.delete_all("shouston3/test")
Hooks.create("shouston3/test", "http://9e5608e3.ngrok.io")

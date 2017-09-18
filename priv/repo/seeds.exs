alias Tudo.{Hook, GithubApi, Issue, Repo}

# Copying parrallel map idea from here:
# http://elixir-recipes.github.io/concurrency/parallel-map/

timeout = 20_000 # 20 seconds

hook_endpoint = System.get_env "HOOK_ENDPOINT"

GithubApi.get_repos("dwyl")
|> Enum.map(fn repo ->
    Task.async(fn ->
      hook_task = Task.async(fn ->
        Hook.create "dwyl/#{repo}", hook_endpoint
      end)
      issue_task = Task.async(fn ->
        GithubApi.get_help_wanted_issues("dwyl/#{repo}")
      end)

      Task.await(hook_task, timeout)
      Task.await(issue_task, timeout)
    end)
  end)
|> Enum.map(&Task.await(&1, timeout))
|> List.flatten
|> Enum.map(&GithubApi.format_data/1)
|> Enum.each(fn (%{"url" => html_url} = issue) ->
    unless Repo.get_by(Issue, url: html_url) do
      %Issue{}
      |> Issue.changeset(issue)
      |> Repo.insert!
    else
      IO.puts "issue already exists in DB: #{issue["title"] }"
    end
  end)

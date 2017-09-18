alias Tudo.{GithubApi, Issue, Repo, Hook}

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
        GithubApi.get_all_issues("dwyl/#{repo}")
      end)

      Task.await(hook_task, timeout)
      Task.await(issue_task, timeout)
    end)
  end)
|> Enum.map(&Task.await(&1, timeout))
|> List.flatten
|> Enum.filter(&GithubApi.help_wanted_or_no_labels?/1)
|> Enum.map(&GithubApi.format_data/1)
|> Enum.reduce([0, 0], fn (%{"url" => html_url} = issue, [inserted, duplicate]) ->
    unless Repo.get_by(Issue, url: html_url) do
      %Issue{}
      |> Issue.changeset(issue)
      |> Repo.insert!

      [inserted + 1, duplicate]
    else
      [inserted, duplicate + 1]
    end
  end)
|> (fn [inserted, duplicate] ->
    IO.puts "#{inserted} issues added to the database"
    if duplicate > 0, do:
      IO.puts "#{duplicate} issues not inserted because they already exist in the database."
  end).()

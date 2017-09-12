alias Tudo.{Hook, GithubApi, Issue, Repo, IssueNoLabels}

# Copying parrallel map idea from here:
# http://elixir-recipes.github.io/concurrency/parallel-map/

timeout = 20_000 # 20 seconds

hook_endpoint = System.get_env "HOOK_ENDPOINT"

repos = GithubApi.get_repos("dwyl")

repos
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
|> Enum.each(fn issue ->
    %Issue{}
    |> Issue.changeset(issue)
    |> Repo.insert!
  end)

repos
|> Enum.map(fn repo ->
    Task.async(fn ->
      issue_task = Task.async(fn ->
        GithubApi.get_all_issues("dwyl/#{repo}")
      end)
      Task.await(issue_task, timeout)
    end)
  end)
|> Enum.map(&Task.await(&1, timeout))
|> List.flatten
|> Enum.filter(&GithubApi.has_no_labels?/1)
|> Enum.map(&GithubApi.format_data/1)
|> Enum.each(fn issue ->
    %IssueNoLabels{}
    |> IssueNoLabels.changeset(issue)
    |> Repo.insert!
  end)

defmodule Tudo.TestHelpers do
  alias Tudo.{Issue, Repo, IssueNoLabels}

  def insert_issue(params \\ %{}) do
    changes = Map.merge(
      %{title: "Issue Title",
        url: "https://github.com/dwyl/tudo/issues/1",
        labels: ["#009800;help wanted"],
        gh_created_at: "2011-04-10T20:09:31Z",
        gh_updated_at: "2011-04-10T20:09:31Z",
        comments_number: 1,
        state: "open",
        assignees: ["shouston3;https://avatars3.githubusercontent.com/u/15983736?v=4&u=8b6cfb76f2bf2c65dc0b215e179abe1d4cf9c42a&s=400"],
        repo_name: "tudo"
       },
       params
    )

    %Issue{}
    |> Issue.changeset(changes)
    |> Repo.insert!
  end

  def insert_issue_no_labels(params \\ %{}) do
    changes = Map.merge(
      %{title: "Issue Title",
        url: "https://github.com/dwyl/tudo/issues/1",
        labels: [],
        gh_created_at: "2011-04-10T20:09:31Z",
        gh_updated_at: "2011-04-10T20:09:31Z",
        comments_number: 1,
        state: "open",
        assignees: ["shouston3;https://avatars3.githubusercontent.com/u/15983736?v=4&u=8b6cfb76f2bf2c65dc0b215e179abe1d4cf9c42a&s=400"],
        repo_name: "tudo"
       },
       params
    )

    %Issue{}
    |> Issue.changeset(changes)
    |> Repo.insert!
  end
end

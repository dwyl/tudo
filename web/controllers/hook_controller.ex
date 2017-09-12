defmodule Tudo.HookController do
  use Tudo.Web, :controller

  alias Tudo.{Repo, Issue, GithubApi}

  @doc"""
  Called when an issue title changes
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"title" => %{"from" => _prev_title}},
                     "issue" => %{"html_url" => html_url,
                                  "labels" => labels,
                                  "updated_at" => gh_updated_at,
                                  "title" => new_title}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{title: new_title, gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end

  @doc"""
  Called when a comment is edited
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"body" => %{"from" => _prev_issue_comment}},
                     "issue" => %{"html_url" => _html_url,
                                  "updated_at" => _gh_updated_at},
                     "comment" => %{"body" => _new_issue_comment}}) do

    # Don't do anything in this scenario
    render conn, "index.json"
  end

  @doc"""
  Called when the body of an issue changes
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"body" => %{"from" => _prev_issue_body}},
                     "issue" => %{"html_url" => _html_url,
                                  "body" => _new_issue_body,
                                  "updated_at" => _gh_updated_at}}) do

    # Don't do anything in this scenario
    render conn, "index.json"
  end

  @doc"""
  Called when an issue comment is created
  """
  def create(conn, %{"action" => "created",
                     "issue" => %{"html_url" => html_url,
                                  "updated_at" => gh_updated_at,
                                  "comments" => prev_comments_number,
                                  "labels" => labels},
                     "comment" => %{"body" => _comment}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{comments_number: prev_comments_number + 1,
                             gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue comment is deleted
  """
  def create(conn, %{"action" => "deleted",
                     "issue" => %{"html_url" => html_url,
                                  "updated_at" => gh_updated_at,
                                  "comments" => prev_comments_number,
                                  "labels" => labels},
                     "comment" => %{"body" => _comment}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{comments_number: prev_comments_number - 1,
                             gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is opened
  """
  def create(conn, %{"action" => "opened",
                     "issue" => %{"body" => _body,
                                  "title" => title,
                                  "assignees" => assignees,
                                  "labels" => labels,
                                  "updated_at" => gh_updated_at,
                                  "html_url" => html_url,
                                  "comments" => comments}}) do

    issue = %{"title" => title, "state" => "open",
              "created_at" => gh_updated_at, "labels" => labels,
              "updated_at" => gh_updated_at, "html_url" => html_url,
              "assignees" => assignees, "comments" => comments}

  if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
    %Issue{}
    |> Issue.changeset(GithubApi.format_data(issue))
    |> Repo.insert!
  end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is closed
  """
  def create(conn, %{"action" => "closed",
                     "issue" => %{"html_url" => html_url,
                                  "labels" => labels,
                                  "updated_at" => gh_updated_at}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{state: "closed", gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is reopened
  """
  def create(conn, %{"action" => "reopened",
                     "issue" => %{"body" => _body,
                                  "title" => title,
                                  "assignees" => assignees,
                                  "labels" => labels,
                                  "updated_at" => gh_updated_at,
                                  "comments" => comments,
                                  "html_url" => html_url}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by(url: html_url)
        |> case do
          nil ->
            issue = %{"title" => title, "labels" => labels, "state" => "open",
                      "created_at" => gh_updated_at, "updated_at" => gh_updated_at,
                      "html_url" => html_url, "assignees" => assignees,
                      "comments" => comments}

            %Issue{}
            |> Issue.changeset(GithubApi.format_data(issue))
            |> Repo.insert!
          issue ->
            issue
            |> Issue.changeset(%{state: "open", gh_updated_at: gh_updated_at})
            |> Repo.update!
        end
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has a label added
  """
  def create(conn, %{"action" => "labeled",
                     "issue" => %{"body" => _body,
                                  "title" => title,
                                  "assignees" => assignees,
                                  "labels" => labels,
                                  "comments" => comments,
                                  "updated_at" => gh_updated_at,
                                  "html_url" => html_url}}) do

    if Enum.find(labels, &(&1["name"] == "help wanted")) do
        Issue
        |> Repo.get_by(url: html_url)
        |> case do
          nil ->
            # New issue needs to be created
            issue = %{"title" => title, "labels" => labels, "state" => "open",
                      "created_at" => gh_updated_at, "updated_at" => gh_updated_at,
                      "html_url" => html_url, "assignees" => assignees,
                      "comments" => comments}

            %Issue{}
            |> Issue.changeset(GithubApi.format_data(issue))
            |> Repo.insert!
          issue ->
            # Issue exists in our database
            # But needs to be updated

            labels = Enum.map labels, &GithubApi.format_label/1

            issue
            |> Issue.changeset(%{labels: labels, gh_updated_at: gh_updated_at})
            |> Repo.update!
        end
      else
        if length(labels) === 1 do
          case Repo.get_by(Issue, url: html_url) do
            nil ->
              nil
            issue ->
              Repo.delete issue
          end
        end
    end
    render conn, "index.json"
  end

  @doc"""
  Called when an issue has a label removed
  """
  def create(conn, %{"action" => "unlabeled",
                     "issue" => %{"body" => _body,
                                  "title" => title,
                                  "assignees" => assignees,
                                  "labels" => labels,
                                  "comments" => comments,
                                  "updated_at" => gh_updated_at,
                                  "html_url" => html_url}}) do

    labels_formatted = Enum.map labels, &GithubApi.format_label/1
    cond do
      Enum.find(labels, &(&1["name"] == "help wanted")) ->
          Issue
          |> Repo.get_by!(url: html_url)
          |> Issue.changeset(%{labels: labels_formatted,
                               gh_updated_at: gh_updated_at})
          |> Repo.update!
      length(labels) == 0 ->
          case Repo.get_by(Issue, url: html_url) do
            nil ->
              issue = %{"title" => title, "state" => "open",
                        "created_at" => gh_updated_at, "labels" => labels, "updated_at" => gh_updated_at,
                        "html_url" => html_url, "assignees" => assignees,
                        "comments" => comments}
              %Issue{}
              |> Issue.changeset(GithubApi.format_data(issue))
              |> Repo.insert!
            issue ->
              issue
              |> Issue.changeset(%{labels: labels_formatted,
                                   gh_updated_at: gh_updated_at})
              |> Repo.update!
          end
      true ->
          case Repo.get_by(Issue, url: html_url) do
            nil ->
              nil
            issue ->
              Repo.delete issue
          end
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has an assignee added
  """
  def create(conn, %{"action" => "assigned",
                     "assignee" => %{"avatar_url" => _avatar_url,
                                     "login" => _login},
                     "issue" => %{"html_url" => html_url,
                                  "assignees" => assignees,
                                  "updated_at" => gh_updated_at,
                                  "labels" => labels}}) do

    assignees = Enum.map assignees, &GithubApi.format_assignees/1

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{assignees: assignees,
                             gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has an assignee removed
  """
  def create(conn, %{"action" => "unassigned",
                     "assignee" => %{"login" => _login},
                     "issue" => %{"html_url" => html_url,
                                  "assignees" => assignees,
                                  "updated_at" => gh_updated_at,
                                  "labels" => labels}}) do
    assignees = Enum.map assignees, &GithubApi.format_assignees/1

    if Enum.find(labels, &(&1["name"] == "help wanted")) || length(labels) === 0 do
        Issue
        |> Repo.get_by!(url: html_url)
        |> Issue.changeset(%{assignees: assignees,
                             gh_updated_at: gh_updated_at})
        |> Repo.update!
    end

    render conn, "index.json"
  end
end

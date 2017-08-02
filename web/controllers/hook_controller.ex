defmodule Tudo.HookController do
  # TODO: add updated at for all actions
  # TODO: change url -> html_url
  use Tudo.Web, :controller

  @doc"""
  Called when an issue title changes
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"title" => %{"from" => prev_title}},
                     "issue" => %{"url" => url, "title" => new_title}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "CHANGED TITLE"
    IO.puts "PREV_TITLE: " <> prev_title
    IO.puts "NEW_TITLE: " <> new_title

    render conn, "index.json"
  end

  @doc"""
  Called when a comment is edited
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"body" => %{"from" => prev_issue_comment}},
                     "issue" => %{"url" => url},
                     "comment" => %{"body" => new_issue_comment}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "COMMENT EDITED"
    IO.puts "PREV_ISSUE_COMMENT: " <> prev_issue_comment
    IO.puts "NEW_ISSUE_COMMENT: " <> new_issue_comment

    render conn, "index.json"
  end

  @doc"""
  Called when the body of an issue changes
  """
  def create(conn, %{"action" => "edited",
                     "changes" => %{"body" => %{"from" => prev_issue_body}},
                     "issue" => %{"url" => url, "body" => new_issue_body}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "ISSUE BODY CHANGED"
    IO.puts "PREV_ISSUE_BODY: " <> prev_issue_body
    IO.puts "NEW_ISSUE_BODY: " <> new_issue_body

    render conn, "index.json"
  end

  @doc"""
  Called when an issue comment is created
  """
  def create(conn, %{"action" => "created",
                     "issue" => %{"url" => url},
                     "comment" => %{"body" => comment}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "CREATED COMMENT: " <> comment

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is opened
  """
  def create(conn, %{"action" => "opened",
                     "issue" => %{"body" => body,
                                  "title" => title,
                                  "assignees" => assignees,
                                  "labels" => labels,
                                  "updated_at" => updated_at,
                                  "url" => url}} = params) do
    IO.puts "ISSUE: " <> url
    IO.puts "ISSUE OPENED"
    IO.puts title
    IO.puts body
    IO.inspect assignees
    IO.inspect labels
    IO.puts "ISSUE CREATED AT: " <> updated_at

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is closed
  """
  def create(conn, %{"action" => "closed",
                     "issue" => %{"url" => url}}) do
    IO.puts "ISSUE CLOSED: " <> url

    render conn, "index.json"
  end

  @doc"""
  Called when an issue is reopened
  """
  def create(conn, %{"action" => "reopened",
                     "issue" => %{"url" => url}}) do
    IO.puts "ISSUE REOPENED: " <> url

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has a label added
  """
  def create(conn, %{"action" => "labeled",
                     "issue" => %{"labels" => labels,
                                  "url" => url,
                                  "updated_at" => updated_at}}) do
    IO.inspect labels
    IO.puts "URL: " <> url
    IO.puts "UPDATED: " <> updated_at

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has a label removed
  """
  def create(conn, %{"action" => "unlabeled",
                     "issue" => %{"url" => url,
                                  "labels" => labels}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "HAD LABEL REMOVED"
    IO.puts "NEW LABELS:"
    IO.inspect labels

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has an assignee added
  """
  def create(conn, %{"action" => "assigned",
                     "assignee" => %{"avatar_url" => avatar_url, "login" => login},
                     "issue" => %{"url" => url}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "ASSIGNED TO: " <> login
    IO.puts "USER IMAGE: " <> avatar_url

    render conn, "index.json"
  end

  @doc"""
  Called when an issue has an assignee removed
  """
  def create(conn, %{"action" => "unassigned",
                     "assignee" => %{"login" => login},
                     "issue" => %{"url" => url}}) do
    IO.puts "ISSUE: " <> url
    IO.puts "UNASSIGNED USER: " <> login

    render conn, "index.json"
  end
end

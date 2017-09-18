defmodule Tudo.HookControllerTest do
  use Tudo.ConnCase

  alias Tudo.{Issue, Repo}

  require Poison

  @gh_prefix "https://github.com/dwyl/tudo"
  @label [%{"name" => "help wanted", "color" => "009800"}]
  @assignee [%{"login": "shouston3", "avatar_url": "https://avatars3.githubusercontent.com/u/15983736?v=4&u=8b6cfb76f2bf2c65dc0b215e179abe1d4cf9c42a&s=400"}]

  @ignored_hooks [
    {"comment is edited", [action: "edited",
                           changes: %{"body" => %{"from" => ""}},
                           issue: %{"html_url" => "", "updated_at" => ""},
                           comment: %{"body" => ""}]
    },
    {"issue body is edited", [action: "edited",
                              changes: %{"body" => %{"from" => ""}},
                              issue: %{"html_url" => "",
                                       "body" => "",
                                       "updated_at" => ""}]
    }
  ]

  test "issues stay the same for ignored hooks", %{conn: conn} do
    default_issue = insert_issue()

    @ignored_hooks |> Enum.each(fn {_description, opts} ->
      conn = post conn, hook_path(conn, :create), opts
      issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

      assert issue == default_issue
      assert json_response(conn, 200) ==
        ~s({"errors": 0, "message": "thankyou"}\n)
    end)
  end

  test "issue title change", %{conn: conn} do
    insert_issue %{title: "Prev Title"}
    opts = [action: "edited",
            changes: %{"title" => %{"from" => "Prev Title"}},
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "labels" => @label,
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "title" => "New Title"}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "New Title"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue title change without labels", %{conn: conn} do
    insert_issue_no_labels %{title: "Prev Title"}
    opts = [action: "edited",
            changes: %{"title" => %{"from" => "Prev Title"}},
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "labels" => [],
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "title" => "New Title"}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "New Title"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue comment is created", %{conn: conn} do
    insert_issue()
    opts = [action: "created",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "comments" => 0,
                     "labels" => @label},
            comment: %{"body" => ""}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.comments_number == 1
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue comment is created with no labels", %{conn: conn} do
    insert_issue_no_labels()
    opts = [action: "created",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "comments" => 0,
                     "labels" => []},
            comment: %{"body" => ""}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.comments_number == 1
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue comment is deleted", %{conn: conn} do
    insert_issue %{comments_number: 1}
    opts = [action: "deleted",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "comments" => 1,
                     "labels" => @label},
            comment: %{"body" => ""}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.comments_number == 0
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue comment is deleted with no labels", %{conn: conn} do
    insert_issue_no_labels()
    opts = [action: "deleted",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "comments" => 1,
                     "labels" => []},
            comment: %{"body" => ""}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.comments_number == 0
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is opened", %{conn: conn} do
    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => []}
    opts = [action: "opened",
            issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "Labeled issue"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is closed", %{conn: conn} do
    insert_issue()
    opts = [action: "closed",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => @label}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.state == "closed"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is closed without labels", %{conn: conn} do
    insert_issue_no_labels()
    opts = [action: "closed",
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => []}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.state == "closed"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is reopened :: not in db", %{conn: conn} do
    issue_params = %{"body" => "Reopened issue body",
                     "title" => "Reopened issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => @label}
    opts = [action: "reopened", issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "Reopened issue"
    assert issue.labels == ["#009800;help wanted"]
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue with no labels is reopened :: not in db", %{conn: conn} do
    issue_params = %{"body" => "Reopened issue body",
                     "title" => "Reopened issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => []}
    opts = [action: "reopened", issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "Reopened issue"
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is reopened :: already in db", %{conn: conn} do
    default_issue = %{state: "closed"}
      |> insert_issue
      |> Map.delete(:updated_at) # we don't want to compare updated_at
    opts = [action: "reopened",
            issue: %{"body" => "",
                     "title" => "",
                     "assignees" => [],
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-10T20:09:31Z",
                     "labels" => @label}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Issue
      |> Repo.get_by!(url: "#{@gh_prefix}/issues/1")
      |> Map.delete(:updated_at) # we don't want to compare updated_at

    assert issue != default_issue
    assert issue == %{default_issue | state: "open"}
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue is reopened with no labels :: already in db", %{conn: conn} do
    default_issue = %{state: "closed"}
      |> insert_issue_no_labels
      |> Map.delete(:updated_at) # we don't want to compare updated_at
    opts = [action: "reopened",
            issue: %{"body" => "",
                     "title" => "",
                     "assignees" => [],
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-10T20:09:31Z",
                     "labels" => []}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Issue
      |> Repo.get_by!(url: "#{@gh_prefix}/issues/1")
      |> Map.delete(:updated_at) # we don't want to compare updated_at

    assert issue != default_issue
    assert issue == %{default_issue | state: "open"}
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has label added :: not in db", %{conn: conn} do
    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => @label}
    opts = [action: "labeled", issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.title == "Labeled issue"
    assert issue.labels == ["#009800;help wanted"]
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has label added :: already in db", %{conn: conn} do
    default_issue = %{labels: []}
      |> insert_issue
      |> Map.delete(:updated_at) # we don't want to compare updated_at
    opts = [action: "labeled",
            issue: %{"body" => "",
                     "title" => "",
                     "assignees" => [],
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-10T20:09:31Z",
                     "labels" => @label}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Issue
      |> Repo.get_by!(url: "#{@gh_prefix}/issues/1")
      |> Map.delete(:updated_at) # we don't want to compare updated_at

    assert issue != default_issue
    assert issue == %{default_issue | labels: ["#009800;help wanted"]}
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has label added and previously had none", %{conn: conn} do
    insert_issue_no_labels()
    opts = [action: "labeled",
            issue: %{"body" => "",
                     "title" => "",
                     "assignees" => [],
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-10T20:09:31Z",
                     "labels" => [%{"name" => "blah", "color" => "009800"}]}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by(Issue, url: "#{@gh_prefix}/issues/1")

    assert issue == nil
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)

  end

  test "help wanted issue has label removed", %{conn: conn} do
    insert_issue(%{labels: ["#009800;help wanted", "#fff;testissue"]})

    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => @label}
    opts = [action: "unlabeled",
            issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts
    issue = Repo.get_by Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.labels == ["#009800;help wanted"]
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "help wanted issue has label removed leaving no labels", %{conn: conn} do
    insert_issue()
    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => []}
    opts = [action: "unlabeled",
            issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue_no_label = Repo.get_by Issue, url: "#{@gh_prefix}/issues/1"

    assert issue_no_label.labels == []
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "non-help wanted issue has label removed leaving no labels", %{conn: conn} do
    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => []}
    opts = [action: "unlabeled",
            issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue_no_label = Repo.get_by Issue, url: "#{@gh_prefix}/issues/1"

    assert issue_no_label.labels == []
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "help wanted issue with other labels has help wanted removed", %{conn: conn} do
    insert_issue(%{labels: ["#009800;help wanted", "#fff;testissue"]})

    test_label = [%{"name" => "testissue", "color" => "fff"}]

    issue_params = %{"body" => "Labeled issue body",
                     "title" => "Labeled issue",
                     "assignees" => @assignee,
                     "comments" => 2,
                     "html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "labels" => test_label}
    opts = [action: "unlabeled",
            issue: issue_params]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by Issue, url: "#{@gh_prefix}/issues/1"

    assert issue == nil
    assert json_response(conn, 200) ==
       ~s({"errors": 0, "message": "thankyou"}\n)

  end

  test "issue has an assignee added when help wanted exists", %{conn: conn} do
    insert_issue(%{assignees: []})
    opts = [action: "assigned",
            assignee: Enum.at(@assignee, 0),
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "assignees" => @assignee,
                     "labels" => @label}]

    conn = post(conn, hook_path(conn, :create), opts)

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.assignees ==
      ["shouston3;https://avatars3.githubusercontent.com/u/15983736?v=4&u=8b6cfb76f2bf2c65dc0b215e179abe1d4cf9c42a&s=400"]
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has an assignee added when no labels", %{conn: conn} do
    insert_issue_no_labels(%{assignees: []})
    opts = [action: "assigned",
            assignee: Enum.at(@assignee, 0),
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "assignees" => @assignee,
                     "labels" => []}]

    conn = post(conn, hook_path(conn, :create), opts)

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.assignees == ["shouston3;https://avatars3.githubusercontent.com/u/15983736?v=4&u=8b6cfb76f2bf2c65dc0b215e179abe1d4cf9c42a&s=400"]
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has an assignee removed", %{conn: conn} do
    insert_issue()
    opts = [action: "unassigned",
            assignee: Enum.at(@assignee, 0),
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "assignees" => [],
                     "labels" => @label}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by! Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.assignees == []
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end

  test "issue has an assignee removed when no labels", %{conn: conn} do
    insert_issue_no_labels()
    opts = [action: "unassigned",
            assignee: Enum.at(@assignee, 0),
            issue: %{"html_url" => "#{@gh_prefix}/issues/1",
                     "updated_at" => "2011-04-22T13:33:48Z",
                     "assignees" => [],
                     "labels" => []}]

    conn = post conn, hook_path(conn, :create), opts

    issue = Repo.get_by Issue, url: "#{@gh_prefix}/issues/1"

    assert issue.assignees == []
    assert json_response(conn, 200) ==
      ~s({"errors": 0, "message": "thankyou"}\n)
  end
end

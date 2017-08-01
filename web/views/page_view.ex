defmodule Tudo.PageView do
  use Tudo.Web, :view

  def generate_avatar(issue) do
    issue.assignees
    |> Enum.map(fn assignee -> String.split(assignee, ";") |> Enum.at(0) end)
  end

end

defmodule Tudo.UnlabelledView do
  use Tudo.Web, :view
  use Rummage.Phoenix.View

  def generate_avatar(issue) do
    issue.assignees
    |> Enum.map(fn assignee -> assignee |> String.split(";") |> Enum.at(0) end)
  end

end

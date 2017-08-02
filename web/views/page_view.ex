defmodule Tudo.PageView do
  use Tudo.Web, :view

  def generate_avatar(issue) do
    issue.assignees
    |> Enum.map(fn assignee -> String.split(assignee, ";") |> Enum.at(0) end)
  end

  def generate_pages(count) do
    pages = round(count / 10)

    print_page_numbers(pages, 1)
  end

  defp print_page_numbers(pages, page_number) do
    last = Enum.take(1..pages, -3)
    first = Enum.take(1..pages, 3)
    
    Enum.concat(first, last)
    |> List.insert_at(3, "...")
  end

end

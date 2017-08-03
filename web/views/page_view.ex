defmodule Tudo.PageView do
  use Tudo.Web, :view
  use Rummage.Phoenix.View

  def generate_avatar(issue) do
    issue.assignees
    |> Enum.map(fn assignee -> assignee |> String.split(";") |> Enum.at(0) end)
  end

  def generate_pages(count) do
    pages = round(count / 10)

    print_page_numbers(pages, 1)
  end

  defp print_page_numbers(pages, page_number) do
    last = Enum.take(1..pages, -3)
    first = Enum.take(1..pages, 3)

    first
    |> Enum.concat(last)
    |> List.insert_at(3, "...")
  end

  def get_label_data(issue) do
    issue.labels
    |> Enum.map(fn label ->
      label
      |> String.split(";")
      |> List.to_tuple
      |> get_label_font_color
    end)
  end

  def get_label_font_color({label_hex, label_name}) do
    rgb_value = label_hex
    |> String.replace("#", "")
    |> String.to_integer(16)

    case rgb_value > 0xffffff / 2 do
      true -> {label_hex, label_name, '#000'}
      false -> {label_hex, label_name, '#fff'}
    end
  end

end

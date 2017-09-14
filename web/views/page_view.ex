defmodule Tudo.PageView do
  use Tudo.Web, :view
  use Rummage.Phoenix.View

  def generate_avatar(issue) do
    issue.assignees
    |> Enum.map(fn assignee -> assignee |> String.split(";") |> Enum.at(0) end)
  end

  def get_label_data(issue) do
    issue.labels
    |> Enum.map(fn label ->
      label
      |> String.split(";")
      |> List.to_tuple
      |> get_label_font_color
    end)
    |> filter_rendered_labels
  end

  def allowed_labels, do: ["help wanted", "awaiting-review", "discuss",
                          "question", "enhancement", "starter",
                          "priority-1", "priority-2", "priority-3",
                          "priority-4", "priority-5"]

  defp filter_rendered_labels(label_list) do
    label_list
    |> Enum.filter(fn %{label_name: label} ->
      Enum.member?(allowed_labels(), label)
    end)
  end

  def get_label_font_color({label_hex, label_name}) do
    rgb_value = label_hex
    |> String.replace("#", "")
    |> String.to_integer(16)

    case rgb_value > 0xffffff / 2 do
      true -> %{label_hex: label_hex, label_name: label_name, font_hex: "#000"}
      false -> %{label_hex: label_hex, label_name: label_name, font_hex: "#fff"}
    end
  end

  def checkbox_value(query_string, label) do
    query_string["search"][label]
  end

  def insert_params(query_string, label) do
    case query_string do
      "" ->
        "search[repo_name]=&search[#{label.label_name}]=true"
      qs ->
        qs <> "&search[#{label.label_name}]=true"
    end
  end
end

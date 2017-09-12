defmodule Tudo.IssueNoLabels do
  use Tudo.Web, :model

  @moduledoc false

  schema "issues_no_labels" do
    field :title, :string
    field :url, :string
    field :gh_created_at, Ecto.Date
    field :gh_updated_at, Ecto.Date
    field :comments_number, :integer
    field :state, :string
    field :assignees, {:array, :string}
    field :repo_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :url, :gh_created_at, :gh_updated_at,
                    :comments_number, :state, :assignees, :repo_name])
    |> validate_required([:title, :url, :gh_created_at, :gh_updated_at,
                          :comments_number, :state, :assignees, :repo_name])
  end
end

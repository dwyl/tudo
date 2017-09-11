defmodule Tudo.Repo.Migrations.AddsNoLabelIssuesTable do
  use Ecto.Migration

  def change do
    create table(:issues_no_labels) do
      add :title, :string
      add :url, :string
      add :gh_created_at, :date
      add :gh_updated_at, :date
      add :comments_number, :integer
      add :state, :string
      add :assignees, {:array, :string}
      add :repo_name, :string

      timestamps()
    end
  end
end

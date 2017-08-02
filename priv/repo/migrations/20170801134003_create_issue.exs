defmodule Tudo.Repo.Migrations.CreateIssue do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :string
      add :url, :string
      add :labels, {:array, :string}
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

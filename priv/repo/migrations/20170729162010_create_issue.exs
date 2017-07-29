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
      add :repository_id, references(:repositories, on_delete: :nothing)

      timestamps()
    end
    create index(:issues, [:repository_id])

  end
end

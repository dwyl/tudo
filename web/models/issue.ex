defmodule Tudo.Issue do
  use Tudo.Web, :model
  @moduledoc false

  schema "issues" do
    field :title, :string
    field :url, :string
    field :labels, {:array, :string}
    field :gh_created_at, Ecto.Date
    field :gh_updated_at, Ecto.Date
    field :comments_number, :integer
    field :state, :string
    field :assignees, {:array, :string}
    belongs_to :repository, Tudo.Repository

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @fields [:title, :url, :labels, :gh_created_at, :gh_updated_at,
           :comments_number, :state, :assignees]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end

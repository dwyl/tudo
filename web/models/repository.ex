defmodule Tudo.Repository do
  use Tudo.Web, :model
  @moduledoc false

  schema "repositories" do
    field :name, :string
    field :url, :string
    has_many :issues, Tudo.Issue

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url])
    |> validate_required([:name, :url])
  end
end

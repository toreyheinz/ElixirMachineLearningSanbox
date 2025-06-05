defmodule BookSearch.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :description, :string
    field :title, :string
    field :author, :string
    field :embedding, Pgvector.Ecto.Vector

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:author, :title, :description, :embedding])
    |> validate_required([:author, :title, :description])
  end

  def put_embedding(%{changes: %{description: desc}} = book_changeset) do
    %{embedding: embedding} = BookSearch.Model.predict(desc)
    put_change(book_changeset, :embedding, embedding)
  end
end

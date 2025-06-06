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

  def put_embedding(%{changes: attrs} = book_changeset) do
    text = "#{attrs.title} by #{attrs.author}: #{attrs.description}"
    %{embedding: embedding_tensor} = BookSearch.Model.predict(text)
    embedding = Nx.to_flat_list(embedding_tensor)

    put_change(book_changeset, :embedding, embedding)
  end
end

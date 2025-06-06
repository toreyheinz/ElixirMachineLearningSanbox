defmodule BookSearch.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias BookSearch.Repo

  alias BookSearch.Library.Book

  # def search(query) do
  #   %{embedding: embedding} = BookSearch.Model.predict(query)

  #   Book
  #   |> order_by([b], l2_distance(b.embedding, ^embedding))
  #   |> limit(5)
  #   |> Repo.all()
  # end

  # def search(query) do
  #   %{embedding: embedding} = BookSearch.Model.predict(query)

  #   from(b in Book,
  #     order_by: [asc: fragment("? <-> ?", b.embedding, ^embedding)],
  #     limit: 5
  #   )
  #   |> Repo.all()
  # end

  def search(query) do
    %{embedding: embedding_tensor} = BookSearch.Model.predict(query)
    # Convert tensor to list
    embedding = Nx.to_flat_list(embedding_tensor)

    from(b in Book,
      order_by: [asc: fragment("? <-> ?", b.embedding, ^embedding)],
      limit: 5
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_book(attrs \\ %{}) do
    book =
      %Book{}
      |> Book.changeset(attrs)
      |> Book.put_embedding()

    Repo.insert(book)
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
end

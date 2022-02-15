defmodule AdeptEcto.Access do
  use Ecto.Schema
  import Ecto.Query

  #--------------------------------------------------------
  # count the total number of rows in a column in a repo
  @spec count(repo :: Ecto.Repo.t(), schema :: Ecto.Queryable.t()) :: pos_integer
  def count( repo, schema ) when is_atom(repo) and is_atom(schema) do
    schema
      |> select([x], count(x.id))
      |> repo.one
  end
  def count( repo, query ) when is_atom(repo) do
    repo.one( query )
  end

  @spec exists?(repo :: Ecto.Repo.t(), query :: Ecto.Queryable.t()) :: boolean
  def exists?(repo, query) when is_atom(repo) do
    count( repo, query ) > 0
  end


  #--------------------------------------------------------
  @spec fetch(repo :: Ecto.Repo.t(), schema :: Ecto.Queryable.t(), id :: term(), opts :: Keyword.t() ) ::
    {:ok, Ecto.Schema.t()}
    | {:error, :not_found}
  def fetch( repo, schema, id, opts \\ [] )
  when is_atom(repo) and is_atom(schema) and is_list(opts) do
    case repo.get(schema, id, opts) do
      nil ->  {:error, :not_found}
      ref -> {:ok, ref}
    end
  end

  @spec fetch_by(
    repo :: Ecto.Repo.t(),
    schema :: Ecto.Queryable.t(),
    clauses :: Keyword.t(),
    opts :: Keyword.t() 
  ) ::
    {:ok, Ecto.Schema.t()}
    | {:error, :not_found}
  def fetch_by( repo, schema, clauses, opts \\ [] )
  when is_atom(repo) and is_atom(schema) and is_list(clauses) and is_list(opts) do
    case repo.get_by(schema, clauses, opts) do
      nil ->  {:error, :not_found}
      ref -> {:ok, ref}
    end
  end


  #--------------------------------------------------------
  # insert_id
  # For generating a record with a randomly generated string id.
  # So... generate a random one and try to insert it.
  # If there is an index violation, then generate another, longer one and try
  # again. If we hit max tries, fail
  def insert_id( changeset, repo, sid_length, tries_left, opts \\ [] ) do
    # gen a random sid
    sid = :crypto.strong_rand_bytes(sid_length)
      |> Base.url_encode64
      |> binary_part(0, sid_length)
    sid = case is_bitstring(opts[:leader]) do
      true -> opts[:leader] <> sid
      _ -> sid
    end

    # jam the sid into the changeset
    changeset = Ecto.Changeset.put_change(changeset, opts[:id] || :id, sid )

    # attempt to insert - catch id constraint errors and retry
    try do
      repo.insert( changeset )
    rescue
      error ->
        case tries_left do
          1 -> raise error
          _ -> insert_id( changeset, repo, sid_length + 1, tries_left - 1, opts )
        end
    end
  end

end
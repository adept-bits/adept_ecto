defmodule AdeptEcto.Access do
  use Ecto.Schema
  import Ecto.Query

#  import IEx

  #----------------------------------------------------------------------------
  # count the total number of rows in a column in a repo
  def count( repo, schema ) when is_atom(repo) and is_atom(schema) do
    schema
      |> select([x], count(x.id))
      |> repo.one
  end

  def count( repo, query ) when is_atom(repo) do
    repo.one( query )
  end

  def exists?(repo, query) when is_atom(repo) do
    count( repo, query ) > 0
  end

  def fetch( repo, schema, id ) when is_atom(repo) and is_atom(schema) do
    case repo.get(schema, id) do
      nil ->  {:error, :not_found}
      ref -> {:ok, ref}
    end
  end

  def fetch_by( repo, schema, opts ) when is_atom(repo) and is_atom(schema) and is_list(opts) do
    case repo.get_by(schema, opts) do
      nil ->  {:error, :not_found}
      ref -> {:ok, ref}
    end
  end

  # list the objects
  def list( repo, schema ), do: repo.all(schema)
  def list( repo, schema, opts ) do
    where = Keyword.get(opts, :where)
    order = Keyword.get(opts, :order_by)
    select = Keyword.get(opts, :select)
    schema
    |> maybe_add_clause( :where, where )
    |> maybe_add_clause( :order_by, order )
    |> maybe_add_clause( :select, select )
    |> repo.all()
  end
  defp maybe_add_clause( query, clause, value )
  defp maybe_add_clause( query, _clause, nil ), do: query
  defp maybe_add_clause( query, _clause, [] ), do: query
  defp maybe_add_clause( query, :where, value ) do
    where( query, ^value )
  end
  defp maybe_add_clause( query, :order_by, value ) do
    order_by( query, ^value )
  end
  defp maybe_add_clause( query, :select, value ) do
    select( query, ^value )
  end

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
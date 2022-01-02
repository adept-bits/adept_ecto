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


  # list the objects
  def list( repo, schema ), do: repo.all(schema)
  # def list( %User{} = user ), do: list( user.id )
      # where: x.user_id == ^user_id,
  def list_inserted_at( repo, schema ) do
    Ecto.Query.from(
      x in schema,
      order_by: [desc: x.inserted_at]
    )
    |> repo.all
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
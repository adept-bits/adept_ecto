defmodule AdeptEcto.AccessTest do
  use ExUnit.Case, async: true
  # use Plug.Test

  defmodule TestRepo do
    def one( _query ), do: 7
    def get( _queryable, 1, _opts ), do: %{id: 1}
    def get( _queryable, 2, _opts ), do: nil
    def get_by(), do: %{id: 1}
    def get_by(_queryable, [abc: 123], _opts), do: %{id: 1}
    def get_by(_queryable, [abc: 456], _opts), do: nil
  end
  defmodule ZeroRepo do
    def one( _query ), do: 0
  end

  defmodule Thing do
    use Ecto.Schema
    import Ecto.Changeset

    schema "things" do
      field :str,   :string
      timestamps()
    end

    @doc false
    def changeset(%Thing{} = local, attrs) do
      local
      |> cast(attrs, [:str])
      |> validate_required([])
    end
  end

  test "count_rows counts the rows..." do
    assert AdeptEcto.Access.count(TestRepo, Thing) == 7
  end

  test "exists? works" do
    assert AdeptEcto.Access.exists?(TestRepo, Thing)
    refute AdeptEcto.Access.exists?(ZeroRepo, Thing)
  end

  test "fetch fetches" do
    assert AdeptEcto.Access.fetch(TestRepo, Thing, 1) == {:ok, %{id: 1}}
  end

  test "fetch returns an error if not found" do
    assert AdeptEcto.Access.fetch(TestRepo, Thing, 2) == {:error, :not_found}
  end

  test "fetch_by fetches" do
    assert AdeptEcto.Access.fetch_by(TestRepo, Thing, abc: 123) == {:ok, %{id: 1}}
  end

  test "fetch_by returns an error if not found" do
    assert AdeptEcto.Access.fetch_by(TestRepo, Thing, abc: 456) == {:error, :not_found}
  end

end

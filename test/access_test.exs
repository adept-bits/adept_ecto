defmodule AdeptEcto.AccessTest do
  use ExUnit.Case, async: true
  # use Plug.Test

  defmodule TestRepo do
    def one( _query ), do: 7
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

  #============================================================================
  # count_rows

  test "count_rows counts the rows..." do
    assert AdeptEcto.Access.count(TestRepo, Thing) == 7
  end

end
defmodule AdeptEcto.ContextTest do
  use ExUnit.Case
  doctest AdeptEcto

  defmodule TestRepo do
    def one( _query ), do: 7
  end

  defmodule Thing do
    use AdeptEcto.Context, TestRepo
  end

  test "count was added" do
    assert Kernel.function_exported?(Thing, :count, 0)
    assert Kernel.function_exported?(Thing, :count, 1)
  end

  test "exists? was added" do
    assert Kernel.function_exported?(Thing, :exists?, 1)
  end

  test "reload was added" do
    assert Kernel.function_exported?(Thing, :reload, 1)
  end

  test "reload! was added" do
    assert Kernel.function_exported?(Thing, :reload!, 1)
  end

  test "list was added" do
    assert Kernel.function_exported?(Thing, :list, 0)
  end

  test "one was added" do
    assert Kernel.function_exported?(Thing, :one, 1)
  end

  test "all was added" do
    assert Kernel.function_exported?(Thing, :all, 1)
  end

  test "get was added" do
    assert Kernel.function_exported?(Thing, :get, 1)
  end

  test "get! was added" do
    assert Kernel.function_exported?(Thing, :get!, 1)
  end

  test "fetch was added" do
    assert Kernel.function_exported?(Thing, :fetch, 1)
  end

  test "get_by was added" do
    assert Kernel.function_exported?(Thing, :get_by, 1)
    assert Kernel.function_exported?(Thing, :get_by, 2)
  end

  test "repo was added" do
    assert Kernel.function_exported?(Thing, :repo, 0)
  end

end
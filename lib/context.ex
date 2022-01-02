defmodule AdeptEcto.Context do

  # ===========================================================================
  # the using macro for scenes adopting this behavior
  defmacro __using__(repo) do
    quote do
      def count(), do: AdeptEcto.Access.count( unquote(repo), __MODULE__ )
      def count( query ), do: AdeptEcto.Access.count( unquote(repo), query )
      def exists?( query ), do: AdeptEcto.Access.exists?( unquote(repo), query )

      def reload( %{id: id} ), do: unquote(repo).get( __MODULE__, id)
      def reload!( %{id: id} ), do: unquote(repo).get!( __MODULE__, id )

      def preload( records, key ), do: unquote(repo).preload( records, key )

      def list(), do: unquote(repo).all( __MODULE__ )
      def list_inserted_at(), do: AdeptEcto.Access.list_inserted_at( unquote(repo), __MODULE__ )
  
      def get(id), do: unquote(repo).get( __MODULE__, id)
      def get!(id), do: unquote(repo).get!( __MODULE__, id)
      def fetch(id), do: unquote(repo).get!( __MODULE__, id)

      def get_by( key, value )when is_atom(key), do: get_by( [{key, value}] )
      def get_by( opts ) when is_list(opts), do: unquote(repo).get_by(__MODULE__, opts)

      def repo(), do: unquote(repo)

      defoverridable count: 0,
        count: 1,
        exists?: 1,
        reload: 1,
        reload!: 1,
        preload: 2,
        list: 0,
        list_inserted_at: 0,
        get: 1,
        get!: 1,
        fetch: 1,
        get_by: 1,
        get_by: 2,
        repo: 0

      # quote
    end

    # defmacro
  end

end
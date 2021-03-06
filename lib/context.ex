defmodule AdeptEcto.Context do

  # ===========================================================================
  # the using macro for scenes adopting this behavior
  defmacro __using__(repo) do
    quote do
      def count(), do: AdeptEcto.Access.count( unquote(repo), __MODULE__ )
      def count( query_opts ), do: AdeptEcto.Access.count( unquote(repo), query_opts )
      def exists?( query_opts ), do: AdeptEcto.Access.exists?( unquote(repo), query_opts )

      def reload( %{id: id} ), do: unquote(repo).get( __MODULE__, id)
      def reload!( %{id: id} ), do: unquote(repo).get!( __MODULE__, id )

      def preload( records, key ), do: unquote(repo).preload( records, key )

      def list(), do: unquote(repo).all( __MODULE__ )
      def list(opts), do: AdeptEcto.Access.list( unquote(repo), __MODULE__, opts )

      def one( query ), do: unquote(repo).one( query )
      def all( query ), do: unquote(repo).all( query )

      def get(id), do: unquote(repo).get( __MODULE__, id)
      def get!(id), do: unquote(repo).get!( __MODULE__, id)
      def fetch(id), do: AdeptEcto.Access.fetch( unquote(repo), __MODULE__, id)

      def get_by( opts ) when is_list(opts), do: unquote(repo).get_by(__MODULE__, opts)
      def fetch_by(opts), do: AdeptEcto.Access.fetch_by( unquote(repo), __MODULE__, opts)

      def repo(), do: unquote(repo)

      defoverridable count: 0,
        count: 1,
        exists?: 1,
        reload: 1,
        reload!: 1,
        preload: 2,
        list: 0,
        list: 1,
        one: 1,
        all: 1,
        get: 1,
        get!: 1,
        fetch: 1,
        get_by: 1,
        fetch_by: 1,
        repo: 0

      # quote
    end

    # defmacro
  end

end
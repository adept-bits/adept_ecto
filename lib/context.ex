defmodule AdeptEcto.Context do

  # ===========================================================================
  # the using macro for scenes adopting this behavior
  defmacro __using__(repo) do
    quote do
      @spec count() :: pos_integer
      def count(), do: AdeptEcto.Access.count( unquote(repo), __MODULE__ )

      @spec count( query :: Ecto.Queryable.t() ) :: pos_integer
      def count( query ), do: AdeptEcto.Access.count( unquote(repo), query )

      @spec exists?( query :: Ecto.Queryable.t() ) :: boolean
      def exists?( query ), do: AdeptEcto.Access.exists?( unquote(repo), query )


      @spec reload( obj :: Ecto.Schema.t() ) :: Ecto.Schema.t() | nil
      def reload( %{id: id} ), do: unquote(repo).get( __MODULE__, id)

      @spec reload( obj :: Ecto.Schema.t() ) :: Ecto.Schema.t()
      def reload!( %{id: id} ), do: unquote(repo).get!( __MODULE__, id )


      @spec preload(structs_or_struct_or_nil, preloads :: term(), opts :: Keyword.t()) ::
        structs_or_struct_or_nil
        when structs_or_struct_or_nil: [Ecto.Schema.t()] | Ecto.Schema.t() | nil
      def preload( records, key, opts \\ [] ), do: unquote(repo).preload( records, key, opts )


      @spec one( query :: Ecto.Queryable.t(), opts :: Keyword.t() ) :: Ecto.Schema.t() | nil
      def one( query, opts \\ [] ), do: unquote(repo).one( query, opts )

      @spec all() :: [Ecto.Schema.t()]
      def all(), do: unquote(repo).all( __MODULE__ )

      @spec all( query :: Ecto.Queryable.t(), opts :: Keyword.t() ) :: [Ecto.Schema.t()]
      def all( query, opts \\ [] ), do: unquote(repo).all( query, opts )


      @spec get( id :: term(), opts :: Keyword.t()) :: Ecto.Schema.t() | nil
      def get(id, opts \\ []), do: unquote(repo).get( __MODULE__, id, opts)

      @spec get!( id :: term(), opts :: Keyword.t()) :: Ecto.Schema.t()
      def get!(id, opts \\ []), do: unquote(repo).get!( __MODULE__, id, opts)

      @spec fetch( id :: term(), opts :: Keyword.t()) :: {:ok, Ecto.Schema.t()} | :error
      def fetch(id, opts \\ []), do: AdeptEcto.Access.fetch( unquote(repo), __MODULE__, id, opts)

      @spec get_by( clauses :: Keyword.t(), opts :: Keyword.t()) :: Ecto.Schema.t() | nil
      def get_by( clauses, opts \\ [] ) when is_list(opts), do: unquote(repo).get_by(__MODULE__, clauses, opts)

      @spec fetch_by( clauses :: Keyword.t(), opts :: Keyword.t()) :: {:ok, Ecto.Schema.t()} | :error
      def fetch_by(clauses, opts \\ []), do: AdeptEcto.Access.fetch_by( unquote(repo), __MODULE__, clauses, opts)

      @spec repo() :: atom
      def repo(), do: unquote(repo)

      defoverridable count: 0,
        count: 1,
        exists?: 1,
        reload: 1,
        reload!: 1,
        preload: 2,
        one: 1, one: 2,
        all: 0, all: 1, all: 2,
        get: 1, get: 2,
        get!: 1, get!: 2,
        fetch: 1, fetch: 2,
        get_by: 1, get_by: 2,
        fetch_by: 1, fetch_by: 2,
        repo: 0

      # quote
    end

    # defmacro
  end

end
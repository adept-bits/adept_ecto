defmodule AdeptEcto.Changeset do
  import Ecto.Changeset

#  import IEx

  #----------------------------------------------------------------------------

Ecto.Changeset

  @spec validate_first_char( struct :: Ecto.Changeset.t(), field :: atom(), opts :: Keyword.t() ) :: Ecto.Changeset.t()
  def validate_first_char( struct, field, opts ) do
    case fetch_change(struct, field) do
      {:ok, nil} ->     struct
      {:ok, value} ->
        first_char = String.first( value )

        is_ok = case opts[:in] do
          nil-> true
          in_str -> String.contains?(in_str, first_char)
        end && case opts[:not_in] do
          nil-> true
          out_str -> !String.contains?(out_str, first_char)
        end

        case is_ok do
          true  -> struct      # is ok. do nothing
          false -> add_error(struct, field, opts[:message] || "Invalid format") 
        end
      _ ->
        # field is not in the changes, return the struct as is
        struct
    end    
  end

  #----------------------------------------------------------------------------
  @spec validate_email( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def validate_email( struct, field ) do
    struct
      |> strip_string_field( field )
      |> downcase_string_field( field )
      |> validate_length( field, min: 1, max: 254 )
      |> validate_format( field, Adept.Regex.email )
  end

  #----------------------------------------------------------------------------
  @spec validate_not_email( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def validate_not_email( struct, field ) do
    struct
      |> strip_string_field( field )
      |> validate_format( field, Adept.Regex.not_email )
  end

  #----------------------------------------------------------------------------
  @spec validate_spaceless( struct :: Ecto.Changeset.t(), field :: atom(), opts :: Keyword.t() ) :: Ecto.Changeset.t()
  def validate_spaceless( struct, field, opts \\ [] ) do
    validate_change(struct, field, fn(f, str) ->
      case str =~ " " do
        true ->  [{f, opts[:message] || "Cannot contain a space"}]
        false -> []
      end
    end)
  end

  #----------------------------------------------------------------------------
  @spec strip_string_field( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def strip_string_field( struct, field ) do
    case fetch_change(struct, field) do
      {:ok, nil} ->     struct
      {:ok, value} ->
        # field is there, strip it and put it back
        # should crash if it isn't a string type
        put_change(struct, field, String.trim(value) )
      _ ->
        # field is not in the changes, return the struct as is
        struct
    end
  end

  #----------------------------------------------------------------------------
  @spec squash_string_field( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def squash_string_field( struct, field ) do
    case fetch_change(struct, field) do
      {:ok, nil} ->     struct
      {:ok, value} ->
        # field is there, strip it and put it back
        # should crash if it isn't a string type
        put_change(struct, field, Adept.String.squash(value) )
      _ ->
        # field is not in the changes, return the struct as is
        struct
    end
  end

  #----------------------------------------------------------------------------
  @spec downcase_string_field( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def downcase_string_field( struct, field ) do
    case fetch_change(struct, field) do
      {:ok, nil} ->     struct
      {:ok, value} ->
        # field is there, strip it and put it back
        # should crash if it isn't a string type
        put_change(struct, field, String.downcase(value) )
      _ ->
        # field is not in the changes, return the struct as is
        struct
    end
  end

  #----------------------------------------------------------------------------
  @spec upcase_string_field( struct :: Ecto.Changeset.t(), field :: atom() ) :: Ecto.Changeset.t()
  def upcase_string_field( struct, field ) do
    case fetch_change(struct, field) do
      {:ok, nil} ->     struct
      {:ok, value} ->
        # field is there, strip it and put it back
        # should crash if it isn't a string type
        put_change(struct, field, String.upcase(value) )
      _ ->
        # field is not in the changes, return the struct as is
        struct
    end
  end

end
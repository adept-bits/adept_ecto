defmodule AdeptEcto.ChangesetTest do
  use ExUnit.Case, async: true
  # use Plug.Test

  # defmodule TestRepo do
  #   def one( _query ), do: 7
  # end
  
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
  # validate_first_char

  test "validate_first_char validates passes first character is included in the string" do
    set = Thing.changeset(%Thing{}, %{str: ":abc"})
    |> AdeptEcto.Changeset.validate_first_char(:str, in: ".:*")
    assert set.valid?
  end

  test "validate_first_char validates fails first character not in the string" do
    set = Thing.changeset(%Thing{}, %{str: "abc"})
    |> AdeptEcto.Changeset.validate_first_char(:str, in: ".:*")
    refute set.valid?
  end

  test "validate_first_char validates passes first character not in excluded string" do
    set = Thing.changeset(%Thing{}, %{str: "abc"})
    |> AdeptEcto.Changeset.validate_first_char(:str, not_in: ".:*")
    assert set.valid?
  end

  test "validate_first_char validates fails first character in excluded string" do
    set = Thing.changeset(%Thing{}, %{str: ":abc"})
    |> AdeptEcto.Changeset.validate_first_char(:str, not_in: ".:*")
    refute set.valid?
  end

  test "validate_first_char does nothing if the field isn't present" do
    set = Thing.changeset(%Thing{}, %{str: ":abc"})
    assert AdeptEcto.Changeset.validate_first_char(set, :missing, not_in: ".:*") == set
  end

  #============================================================================
  # validate_email

  test "validate_email passes valid email" do
    set = Thing.changeset(%Thing{}, %{str: "user@example.com"})
    |> AdeptEcto.Changeset.validate_email(:str)
    assert set.valid?
  end

  test "validate_email fails invalid email" do
    set = Thing.changeset(%Thing{}, %{str: "user.example.com"})
    |> AdeptEcto.Changeset.validate_email(:str)
    refute set.valid?
  end

  #============================================================================
  # validate_not_email

  test "validate_not_email fails valid email" do
    set = Thing.changeset(%Thing{}, %{str: "user@example.com"})
    |> AdeptEcto.Changeset.validate_not_email(:str)
    refute set.valid?
  end

  test "validate_not_email passes invalid email" do
    set = Thing.changeset(%Thing{}, %{str: "user.example.com"})
    |> AdeptEcto.Changeset.validate_not_email(:str)
    assert set.valid?
  end

  #============================================================================
  # strip_string_field

  test "strip_string_field strips spaces of the front and end, but leaves the middle alone" do
    set = Thing.changeset(%Thing{}, %{str: " A string   with some spaces.  "})
    |> AdeptEcto.Changeset.strip_string_field(:str)
    assert set.changes.str == "A string   with some spaces."
  end

  #============================================================================
  # squash_string_field

  test "squash_string_field strips spaces of the front and end, and squashes the middle" do
    set = Thing.changeset(%Thing{}, %{str: " A string   with some spaces.  "})
    |> AdeptEcto.Changeset.squash_string_field(:str)
    assert set.changes.str == "A string with some spaces."
  end

  #============================================================================
  # downcase_string_field

  test "downcase_string_field downcases the string" do
    set = Thing.changeset(%Thing{}, %{str: " A string   with some spaces.  "})
    |> AdeptEcto.Changeset.downcase_string_field(:str)
    assert set.changes.str == " a string   with some spaces.  "
  end

  #============================================================================
  # upcase_string_field

  test "upcase_string_field upcases the string" do
    set = Thing.changeset(%Thing{}, %{str: " A string   with some spaces.  "})
    |> AdeptEcto.Changeset.upcase_string_field(:str)
    assert set.changes.str == " A STRING   WITH SOME SPACES.  "
  end

end
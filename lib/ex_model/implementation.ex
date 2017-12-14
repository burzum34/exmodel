defmodule ExModel.Implementation do
  @moduledoc """
  User modules of ExModule have functions generated that dispatch to the
  corresponding functions in this module, and injects the declaration as the
  last argument.
  """
  alias ExModel.Declaration

  @doc """
  Given a declaration, this function returns an empty model object.
  """
  def new(declaration), do: new([], declaration)

  @doc """
  Given a keyword list or a map, and a declaration, this function returns a
  model object with it's attributes assigned according to the given ones.
  """
  def new(attributes, declaration), do: declaration
    |> initialize_struct
    |> set_default_attributes(declaration)
    |> assign_attributes(attributes, declaration)

  @doc """
  Given a model object, a key, a value, and a declaration, this function returns
  a new model object with the corresponding attribute set to the given value.
  """
  def put(object, key, value, declaration), do:
    assign_attribute(object, {key, value}, declaration)

  @doc """
  Given a model object, a keyword list or map, and a declaration, this function
  returns a new model object with the corresponding attributes assigned.
  """
  def put_all(object, attributes, declaration), do:
    Enum.reduce(attributes, object, &(assign_attribute &2, &1, declaration))

  @doc """
  Given a model object, a key, and a declaration, this function returns the
  model object's corresponding attribute value, or nil if not found.
  """
  def get(object, key, declaration) do
    assert_declared(key, declaration)
    object.attributes
      |> Map.merge(object.changes)
      |> Map.get(key)
  end

  @doc """
  Given a model object and a declaration, this function returns a Map
  representation of the model object.
  """
  def get_all(object, declaration), do:
    get_all(object, Map.keys(declaration.fields), declaration)

  @doc """
  Given a model object, a list of keys as atoms, and a declaration, this
  function returns the corresponding values as a Map.
  """
  def get_all(object, keys, declaration), do: keys
    |> Enum.map(&({&1, get(object, &1, declaration)}))
    |> Enum.into(Map.new)

  @doc """
  Given a model object, a key, and a declaration, this function returns the
  corresponding value at the time directly after the most recent clearing of
  changes.
  """
  def get_old(object, key, declaration) do
    assert_declared(key, declaration)
    Map.get(object.attributes, key)
  end

  @doc """
  Given a model object and a declaration, this function returns all values at
  the time directly after the most recent clearing of changes, as a Map.
  """
  def get_all_old(object, declaration), do:
    get_all_old(object, Map.keys(declaration.fields), declaration)

  @doc """
  Given a model object, a list of keys, and a declaration, this function returns
  the corresponding values at the time directly after the most recent clearing
  of changes, as a Map.
  """
  def get_all_old(object, keys, declaration), do: keys
    |> Enum.map(&({&1, get_old(object, &1, declaration)}))
    |> Enum.into(Map.new())

  @doc """
  Returns true if the given object has any unsaved changes.
  """
  def changed?(object), do: !(Enum.empty?(object.changes))

  @doc """
  Returns true if the given object has any unsaved changes in attributes specified
  by fields.
  """
  def changed?(object, fields), do: !(object |> changeset(fields) |> Enum.empty?)

  @doc """
  Returns the given object's unsaved changes as a map.
  """
  def changeset(object), do: object.changes

  @doc """
  Returns a map with the unsaved changes in object specified by fields.
  """
  def changeset(object, fields), do: changeset(object)
    |> Enum.filter(fn({k, _v}) -> Enum.member?(fields, k) end)

  @doc """
  Given an object, this function returns a new object where all attributes are
  considered unchanged.
  """
  def clear_changes(object) do
    attributes = Map.merge(object.attributes, object.changes)
    %{object | attributes: attributes, changes: Map.new()}
  end

  #
  # Private
  #

  defp initialize_struct(declaration), do:
    struct(declaration.module, attributes: %{}, changes: %{})

  defp set_default_attributes(object, declaration), do: declaration.fields
    |> Map.values
    |> Enum.reduce(object, &set_default_attribute(&2, &1, declaration))

  defp set_default_attribute(object, field, declaration), do:
    assign_attribute(object, {field.name, field.default}, declaration)

  defp assign_attributes(object, attributes, declaration), do:
    Enum.reduce(attributes, object, &assign_attribute(&2, &1, declaration))

  defp assign_attribute(object, {key, value}, declaration) do
    assert_declared(key, declaration)
    transient = declaration.fields[key].transient
    assign_attribute(object, key, value, transient)
  end

  defp assign_attribute(object, key, value, false), do:
    assign_regular_attribute(object, key, value)
  defp assign_attribute(object, key, value, true), do:
    assign_transient_attribute(object, key, value)

  defp assign_regular_attribute(object, key, value) do
    case Map.has_key?(object.attributes, key) do
      false -> # This is a new object that has never had changes cleared.
        changes = Map.put(object.changes, key, value)
        Map.put(object, :changes, changes)
      true -> case object.attributes[key] == value do
        true -> # Changed back to the original value
          changes = Map.delete(object.changes, key)
          Map.put(object, :changes, changes)
        false ->
          changes = Map.put(object.changes, key, value)
          Map.put(object, :changes, changes)
      end
    end
  end

  defp assign_transient_attribute(object, key, value) do
    attributes = Map.put(object.attributes, key, value)
    %{object | attributes: attributes}
  end

  def assert_declared(key, declaration), do:
    Declaration.assert_declared(declaration, key)
end

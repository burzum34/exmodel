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
  def new(attributes, declaration) do
    acc = struct(declaration.module, [])
    Enum.reduce(attributes, acc, &(assign_attribute &2, &1, declaration))
  end

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
  def get(object, key, declaration), do:
    get(object, key, nil, declaration)

  @doc """
  Given a model object, a key, a default value, and a declaration, this function
  returns the model object's corresponding attribute value, or the given default
  value if not found.
  """
  def get(object, key, default, declaration) do
    assert_declared(key, declaration)
    Map.get(object.attributes, key, default)
  end

  #
  # Private
  #

  defp assign_attribute(object, {key, value}, declaration) do
    assert_declared(key, declaration)
    attributes = Map.put(object.attributes, key, value)
    Map.put(object, :attributes, attributes)
  end

  def assert_declared(key, declaration), do:
    Declaration.assert_declared(declaration, key)
end

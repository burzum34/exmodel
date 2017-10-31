defmodule ExModel.Declaration do
  @moduledoc """
  """
  alias ExModel.FieldDeclaration

  defstruct(
    module: nil,
    fields: %{}
  )

  @doc """
  """
  def new(module), do: %__MODULE__{module: module}

  @doc """
  """
  def add_field(declaration, field_name) when is_list(field_name), do:
    Enum.reduce(field_name, declaration, &(add_field &2, &1))
  def add_field(declaration, field_name), do:
    add_field(declaration, field_name, [])

  @doc """
  """
  def add_field(declaration, field_name, options) do
    field_declaration = FieldDeclaration.new(field_name, options)
    fields = Map.put(declaration.fields, field_name, field_declaration)
    %{declaration | fields: fields}
  end

  @doc """
  """
  def assert_declared(declaration, field_name), do:
    assert_declared(declaration, field_name, declared?(declaration, field_name))

  #
  #
  #

  defp assert_declared(_declaration, field_name, false), do:
    raise "Undeclared attribute '#{field_name}'"
  defp assert_declared(_declaration, _field_name, true), do: true

  defp declared?(declaration, field_name), do:
    Map.has_key?(declaration.fields, field_name)
end

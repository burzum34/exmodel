defmodule ExModel.Declaration do
  @moduledoc """
  """

  defstruct(
    module: nil,
    field_names: MapSet.new,
    default_values: Map.new
  )

  @doc """
  """
  def new(module), do: %__MODULE__{module: module}

  @doc """
  """
  def add_field(declaration, field_name) when is_list(field_name), do:
    Enum.reduce(field_name, declaration, &(add_field &2, &1))
  def add_field(declaration, field_name) do
    field_names = MapSet.put(declaration.field_names, field_name)
    Map.put(declaration, :field_names, field_names)
  end

  @doc """
  """
  def add_field(declaration, field_name, options) do
    default        = Keyword.get(options, :default)
    field_names    = MapSet.put(declaration.field_names, field_name)
    default_values = Map.put(declaration.default_values, field_name, default)
    %{declaration | field_names: field_names, default_values: default_values}
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
    MapSet.member?(declaration.field_names, field_name)
end

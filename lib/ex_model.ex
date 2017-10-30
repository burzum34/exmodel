defmodule ExModel do
  @moduledoc """
  Documentation for Exmodel.
  """
  alias ExModel.Declaration
  alias ExModel.Implementation

  defmacro __using__(_opts) do
    quote do
      import ExModel
      @declaration Declaration.new(__MODULE__)
      @before_compile ExModel
    end
  end

  defmacro attribute(name) do
    quote do
      @declaration Declaration.add_field(@declaration, unquote(name))
    end
  end

  defmacro attribute(name, options) do
    quote do
      @declaration Declaration.add_field(
        @declaration, unquote(name), unquote(options))
    end
  end

  defmacro __before_compile__(_env) do
        quote do
      defstruct(
        attributes: %{},
        old_attributes: %{},
        errors: %{}
      )

      def new, do: Implementation.new(@declaration)

      def new(attributes), do: Implementation.new(attributes, @declaration)

      def put(object, key, value), do:
        Implementation.put(object, key, value, @declaration)

      def put_all(object, enumerable), do:
        Implementation.put_all(object, enumerable, @declaration)

      def get(object, key), do: Implementation.get(object, key, @declaration)

      def get(object, key, default), do:
        Implementation.get(object, key, default, @declaration)

      def changed?(object), do: Implementation.changed?(object)

      def changed?(object, fields), do: Implementation.changed?(object, fields)

      def changeset(object), do: Implementation.changeset(object)

      def changeset(object, fields), do: Implementation.changeset(object, fields)

      def clear_changes(object), do: Implementation.clear_changes(object)
    end
  end
end

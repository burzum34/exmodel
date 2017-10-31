defmodule ExModel.FieldDeclaration do
  @moduledoc false

  defstruct(
    name: nil,
    default: nil,
    transient: false)

  def new(name, options) do
    default = Keyword.get(options, :default)
    transient = Keyword.get(options, :transient, false)
    %__MODULE__{name: name, default: default, transient: transient}
  end
end

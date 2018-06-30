[![Build Status](https://travis-ci.org/burzum34/exmodel.svg?branch=master)](https://travis-ci.org/burzum34/exmodel)

# ExModel

ExModel is a small Elixir library loosely inspired by ActiveModel in Ruby.

It provides a way of declaring model objects with attributes, and the ability to track or clear changes to those attributes.

## Installation

Add `exmodel` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exmodel, "0.1.0", git: "https://github.com/burzum34/exmodel.git"}]
end
```

## Examples

### Declaring a model

A model is declared by using the ExModel module together with the `attribute` macro:

```elixir
defmodule MyModel do
  use ExModel

  attribute :foo
  attribute :bar
end
```

### Instantiating a model object

Using the `new/0` function:

```elixir
object = MyModel.new()
MyModel.get_all(object)
# => %{foo: nil, bar: nil}
```

Using the `new/1` function:

```elixir
object = MyModel.new(foo: "foo")
MyModel.get_all(object)
# => %{foo: "foo", bar: nil}
```

### Assigning attributes

Assigning a single attribute using the `put/3` function:

```elixir
object = MyModel.new()
object = MyModel.put(object, :foo, "foo")
MyModel.get_all(object)
# => %{foo: "foo", bar: nil}
```

Assigning multiple attributes using the `put_all/2` function:

```elixir
object = MyModel.new()
object = MyModel.put_all(object, foo: "foo", bar: "bar")
MyModel.get_all(object)
# => %{foo: "foo", bar: "bar"}
```

### Tracking changes

When a new object is created, all attributes are considered to be changed:

```elixir
object = MyModel.new()
MyModel.changed?(object)
# => true

MyModel.changeset(object)
# => %{bar: nil, foo: nil}
```

Changes can be cleared by the `clear_changes/1` function:

```elixir
object = MyModel.new()
object = MyModel.clear_changes(object)

MyModel.changed?(object)
# => false

MyModel.changeset(object)
# => %{}
```

### Getting the previous value of an attribute

Even if an attribute has been updated, the value at the time of the most recent call to `clear_changes/1` can still be obtained through the `get_old/2` and `get_all_old/1` functions:

```elixir
object = MyModel.new(foo: "foo", bar: "bar")
object = MyModel.clear_changes(object)
object = MyModel.put(object, :foo, "frozz")

MyModel.get_old(object, :foo)
# => "foo"

MyModel.get_all_old(object)
# => %{bar: "bar", foo: "foo"}

```

### Default values

It is possible to declare a default value of an attribute:

```elixir
defmodule MyModel do
  use ExModel

  attribute :foo, default: "foo"
  attribute :bar
end

object = MyModel.new()
MyModel.get_all(object)
# => %{foo: "foo", bar: nil}
```
### Transient attributes

An attribute can be declared to be *transient*. That means that changes to the attribute will not be considered by the change tracking mechanism:

```elixir
defmodule MyModel do
  use ExModel

  attribute :foo
  attribute :bar, transient: true
end

object = MyModel.new(foo: "foo", bar: "bar")
MyModel.changeset(object)
# => %{foo: "foo"}
```

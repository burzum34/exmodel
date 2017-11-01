defmodule ExModel.AccessSpec do
  @moduledoc false
  use ESpec

  defmodule Subject do
    @moduledoc false
    use ExModel
    attribute [:foo, :bar]
  end

  describe "new/0" do
    subject do: Subject.new

    it "returns an empty object" do
      expect(subject().attributes).to eq %{foo: nil, bar: nil}
    end
  end

  describe "new/1" do
    subject do: Subject.new(given_attributes())

    context "when the given attributes have been declared" do
      let :given_attributes, do: [foo: "foo", bar: "bar"]
      
      it "assigns the attributes" do
        expect(subject().attributes[:foo]).to eq "foo"
      end
    end

    context "when a given attribute has not been declared" do
      let :given_attributes, do: [frozz: "frozz"]
      
      it "raises an exception" do
        expect(fn -> subject() |> IO.inspect end).to(
          raise_exception(RuntimeError))
      end
    end
  end

  describe "put/2" do
    subject do: Subject.put(Subject.new(), attribute(), value())
    let :value, do: "foo"

    context "when the given attribute has been declared" do
      let :attribute, do: :foo

      it "assigns the attribute" do
        expect(Subject.get subject(), attribute()).to eq value()
      end
    end

    context "when the given attribute has not been declared" do
      let :attribute, do: :frozz

      it "raises an exception" do
        expect(fn -> subject() |> IO.inspect end).to(
          raise_exception(RuntimeError))
      end
    end
  end

  describe "put_all/2" do
    subject do: Subject.put_all(Subject.new, attributes())

    context "when the given attributes are declared" do
      let :attributes, do: [foo: "foo", bar: "bar"]

      it "assigns the attributes" do
        expect(Subject.get(subject(), :foo)).to eq "foo"
        expect(Subject.get(subject(), :bar)).to eq "bar"
      end
    end

    context "when a given attribute has not been declared" do
      let :attributes, do: [foo: "foo", bar: "bar", frozz: "frozz"]

      it "raises an exception" do
        expect(fn -> subject() |> IO.inspect end).to(
          raise_exception(RuntimeError))
      end
    end
  end

  describe "get/2" do
    subject do: Subject.new()
      |> Subject.put(:foo, value())
      |> Subject.get(attribute())

    let :value, do: "foo"

    context "when the given attribute has been set" do
      let :attribute, do: :foo

      it "returns the attribute value" do
        expect(subject()).to eq value()
      end
    end

    context "when the given attribute has not been set" do
      let :attribute, do: :bar

      it "returns nil" do
        expect(subject()).to be_nil()
      end
    end

    context "when the given attribute has not been declared" do
      let :attribute, do: :frozz

      it "raises an exception" do
        expect(fn -> subject() |> IO.inspect end).to(
          raise_exception(RuntimeError))
      end
    end
  end

  describe "get_all/1" do
    subject do: Subject.new()
      |> Subject.put_all(foo: "foo")
      |> Subject.get_all()

    it "returns all values as a map" do
      expect(subject).to eq %{foo: "foo", bar: nil}
    end
  end

  describe "get_all/2" do
    subject do: Subject.new()
      |> Subject.put_all(foo: "foo", bar: "bar")
      |> Subject.get_all([:foo])

    it "returns the values for the given keys as a map" do
      expect(subject).to eq %{foo: "foo"}
    end
  end

  describe "get_old/1" do
    subject do: Subject.new()
      |> Subject.put_all(foo: "foo", bar: "bar")
      |> Subject.clear_changes
      |> Subject.put(:foo, "frozz")
      |> Subject.put(:foo, "baz")
      |> Subject.get_old(attribute)

    context "when the given attribute has not been declared" do
      let :attribute, do: :frozz

      it "raises an exception" do
        expect(fn -> subject() |> IO.inspect end).to(
          raise_exception(RuntimeError))
      end
    end

    context "when the given attribute has been declared" do
      let :attribute, do: :foo

      it "returns the value after the most recent call to clear_changes/1" do
        expect(subject).to eq "foo"
      end
    end
  end

  describe "get_all_old/1" do
    subject do: Subject.new()
      |> Subject.put_all(foo: "foo", bar: "bar")
      |> Subject.clear_changes
      |> Subject.put(:foo, "frozz")
      |> Subject.put(:bar, "baz")
      |> Subject.get_all_old()

    it "returns the all values after most recent call to clear_changes/1" do
      expect(subject).to eq %{foo: "foo", bar: "bar"}
    end
  end

  describe "get_all_old/2" do
    subject do: Subject.new()
      |> Subject.put_all(foo: "foo", bar: "bar")
      |> Subject.clear_changes
      |> Subject.put(:foo, "frozz")
      |> Subject.put(:bar, "baz")
      |> Subject.get_all_old([:foo])

    it "returns the values after most recent call to clear_changes/1" do
      expect(subject).to eq %{foo: "foo"}
    end
  end
end

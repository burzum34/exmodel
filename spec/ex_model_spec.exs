defmodule ExModel.Spec do
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
      expect(subject().attributes).to eq %{}
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

  describe "get/3" do
    subject do: Subject.new()
      |> Subject.put(:foo, value())
      |> Subject.get(attribute(), default_value())

    let :value,         do: "foo"
    let :default_value, do: "frozz"

    context "when the given attribute has been set" do
      let :attribute, do: :foo

      it "returns the attribute value" do
        expect(subject()).to eq value()
      end
    end

    context "when the given attribute has not been set" do
      let :attribute, do: :bar

      it "returns the default value" do
        expect(subject()).to eq default_value()
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
end

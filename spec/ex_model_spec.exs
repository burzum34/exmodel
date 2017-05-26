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
end

defmodule ExModel.DefaultValuesSpec do
  @moduledoc false
  use ESpec

  defmodule Subject do
    @moduledoc false
    use ExModel

    attribute :foo, default: "foo"
    attribute :bar
  end

  describe "new/0" do
    subject do: Subject.new()

    it "sets the default value" do
      expect(Subject.get subject(), :foo).to eq "foo"
    end
  end

  describe "new/1" do
    subject do: Subject.new(given_attributes())

    context "when the attribute with a default value is given" do
      let :given_attributes, do: [foo: nil]

      it "overrides the declared default value" do
        expect(Subject.get subject(), :foo).to eq nil
      end
    end
  end
end

defmodule ExModel.ChangesSpec do
  @moduledoc false
  use ESpec

  defmodule Subject do
    @moduledoc false
    use ExModel

    attribute :foo
    attribute :bar
    attribute :baz, transient: true
  end

  describe "changed?/1" do
    context "when an empty object has been created" do
      subject do: Subject.new()

      it "returns true" do
        expect(Subject.changed? subject()).to be true
      end
    end

    context "when an attribute has been set" do
      subject do: Subject.new
        |> Subject.clear_changes
        |> Subject.put(:foo, "foo")

      it "returns true" do
        expect(Subject.changed? subject()).to be true
      end
    end

    context "when a transient attribute has been set" do
      subject do: Subject.new
        |> Subject.clear_changes
        |> Subject.put(:baz, "baz")

      it "returns false" do
        expect(Subject.changed? subject()).to be false
      end
    end
  end

  describe "changeset/1" do
    context "when an empty object has been created" do
      subject do: Subject.changeset(Subject.new())

      it "returns an full changeset" do
        expect(subject()).to eq %{foo: nil, bar: nil}
      end
    end

    context "when an attribute has been set" do
      subject do: Subject.new
        |> Subject.clear_changes
        |> Subject.put(:foo, "foo")
        |> Subject.changeset

      it "includes the attribute" do
        expect(subject()).to eq %{foo: "foo"}
      end
    end

    context "when a transient attribute has been set" do
      subject do: Subject.new
        |> Subject.clear_changes
        |> Subject.put(:baz, "baz")
        |> Subject.changeset

      it "does not include the attribute" do
        expect(subject()).to eq %{}
      end
    end

    context "when an attribute is updated to the previous value" do
      subject do: Subject.new()
        |> Subject.put(:foo, "foo")
        |> Subject.clear_changes
        |> Subject.put(:foo, "foo")
        |> Subject.changeset

      it "does not include the attribute" do
        expect(subject()).to eq %{}
      end
    end
  end

  describe "clear_changes/1" do
    subject do: [foo: "foo"]
      |> Subject.new
      |> Subject.clear_changes

    it "clears all changes" do
      expect(Subject.changed? subject()).to be false
      expect(Subject.changeset subject()).to be_empty()
    end
  end
end

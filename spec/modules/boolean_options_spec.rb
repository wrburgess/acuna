require "rails_helper"

describe BooleanOptions, type: :module do
  it "renders a type" do
    expect(described_class::YES).to eq "yes"
    expect(described_class::NO).to eq "no"
    expect(described_class::ANY).to eq "any"
  end

  context ".all" do
    it "returns a list of all types" do
      expect(described_class.all).to include("any", "yes", "no")
    end
  end

  context ".options_for_select" do
    it "returns select options" do
      expect(described_class.options_for_select).to eq [
        [described_class::ANY.titleize,described_class::ANY],
        [described_class::YES.titleize,described_class::YES],
        [described_class::NO.titleize,described_class::NO],
      ]
    end
  end
end

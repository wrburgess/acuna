require "rails_helper"

describe RailsLogLevelTypes, type: :module do
  it "renders a level" do
    expect(described_class::WARN).to eq :warn
  end

  it "renders all types" do
    expect(described_class.all).to include :warn, :debug, :info
  end
end

require 'rails_helper'

RSpec.describe "screeners/show", type: :view do
  before(:each) do
    assign(:screener, Screener.create!(
      name: "Name",
      description: "MyText",
      amount: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
  end
end

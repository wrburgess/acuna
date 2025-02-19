require 'rails_helper'

RSpec.describe "screeners/index", type: :view do
  before(:each) do
    assign(:screeners, [
      Screener.create!(
        name: "Name",
        description: "MyText",
        amount: 2
      ),
      Screener.create!(
        name: "Name",
        description: "MyText",
        amount: 2
      )
    ])
  end

  it "renders a list of screeners" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end

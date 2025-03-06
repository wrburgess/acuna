require 'rails_helper'

RSpec.describe "screeners/edit", type: :view do
  let(:screener) {
    Screener.create!(
      name: "MyString",
      description: "MyText",
      amount: 1
    )
  }

  before(:each) do
    assign(:screener, screener)
  end

  it "renders the edit screener form" do
    render

    assert_select "form[action=?][method=?]", screener_path(screener), "post" do

      assert_select "input[name=?]", "screener[name]"

      assert_select "textarea[name=?]", "screener[description]"

      assert_select "input[name=?]", "screener[amount]"
    end
  end
end

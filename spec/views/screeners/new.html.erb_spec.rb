require 'rails_helper'

RSpec.describe "screeners/new", type: :view do
  before(:each) do
    assign(:screener, Screener.new(
      name: "MyString",
      description: "MyText",
      amount: 1
    ))
  end

  it "renders new screener form" do
    render

    assert_select "form[action=?][method=?]", screeners_path, "post" do

      assert_select "input[name=?]", "screener[name]"

      assert_select "textarea[name=?]", "screener[description]"

      assert_select "input[name=?]", "screener[amount]"
    end
  end
end

require 'rails_helper'

RSpec.describe "pizzas/edit", type: :view do
  let(:pizza) {
    Pizza.create!(
      name: "MyString",
      vegan: false
    )
  }

  before(:each) do
    assign(:pizza, pizza)
  end

  it "renders the edit pizza form" do
    render

    assert_select "form[action=?][method=?]", pizza_path(pizza), "post" do

      assert_select "input[name=?]", "pizza[name]"

      assert_select "input[name=?]", "pizza[vegan]"
    end
  end
end

require 'rails_helper'

RSpec.describe "pizzas/new", type: :view do
  before(:each) do
    assign(:pizza, Pizza.new(
      name: "MyString",
      vegan: false
    ))
  end

  it "renders new pizza form" do
    render

    assert_select "form[action=?][method=?]", pizzas_path, "post" do

      assert_select "input[name=?]", "pizza[name]"

      assert_select "input[name=?]", "pizza[vegan]"
    end
  end
end

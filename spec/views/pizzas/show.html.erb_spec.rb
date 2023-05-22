require 'rails_helper'

RSpec.describe "pizzas/show", type: :view do
  before(:each) do
    assign(:pizza, Pizza.create!(
      name: "Name",
      vegan: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end

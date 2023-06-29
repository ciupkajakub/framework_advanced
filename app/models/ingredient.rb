class Ingredient < ApplicationRecord
  belongs_to :pizza, touch: true
end

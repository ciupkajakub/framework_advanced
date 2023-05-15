class Student < ApplicationRecord
  has_many :posts, as: :postable
end

class Teacher < ApplicationRecord
  has_many :posts, as: :postable
end

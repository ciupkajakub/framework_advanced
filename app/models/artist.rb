class Artist < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true, format: { without: /\A\s+\z/, message: 'cannot be empty' }
  has_many :items, dependent: :destroy
end

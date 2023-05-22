class Pet < ApplicationRecord
  def self.find_by_id(id)
    pet = Pet.find_by(id:)

    pet || NullObjects::NullPet.new
  end
end

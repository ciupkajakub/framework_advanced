require 'rails_helper'

RSpec.describe Pet, type: :model do
  it 'behaves as STI' do
    Dog.create(name: 'Misiek', breed: 'owczarek', age: 2)
    Cat.create(name: 'Pimpek', breed: 'dachowiec', age: 2)
    Cat.create(name: 'Klaczek', breed: 'dachowiec', age: 2)

    expect(Pet.count).to eq(3)
    expect(Dog.count).to eq(1)
    expect(Cat.count).to eq(2)
  end

  describe '#find_by_id' do
    it 'finds a record by the id or returns a null object when record missing', :aggregate_failures do
      dog = Dog.create(name: 'Misiek', breed: 'owczarek', age: 2)
      cat = Cat.create(name: 'Pimpek', breed: 'dachowiec', age: 2)
      null_pet = Pet.find_by_id(12345566665334343434343)

      expect(Pet.find_by_id(dog.id)).to eq(dog)
      expect(Pet.find_by_id(cat.id)).to eq(cat)
      expect(null_pet).to be_an_instance_of(NullObjects::NullPet)
      expect(null_pet).to have_attributes(name: 'null name', breed: 'null breed')
    end
  end
end

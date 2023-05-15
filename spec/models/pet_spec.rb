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
end

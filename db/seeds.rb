sushi_place = Restaurant.create!(name: 'Sushi Place', address: '123 Main Street')
burger_place = Restaurant.create!(name: 'Burger Place', address: '456 Other Street')

sushi_place.dishes.create!(name: 'Volcano Roll', rating: 3)
sushi_place.dishes.create!(name: 'Salmon Nigiri', rating: 4)

burger_place.dishes.create!(name: 'Barbecue Burger', rating: 5)
burger_place.dishes.create!(name: 'Slider', rating: 3)

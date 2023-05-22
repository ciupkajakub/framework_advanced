sushi_place = Restaurant.create!(name: 'Sushi Place', address: '123 Main Street')
burger_place = Restaurant.create!(name: 'Burger Place', address: '456 Other Street')

sushi_place.dishes.create!(name: 'Volcano Roll', rating: 3)
sushi_place.dishes.create!(name: 'Salmon Nigiri', rating: 4)

burger_place.dishes.create!(name: 'Barbecue Burger', rating: 5)
burger_place.dishes.create!(name: 'Slider', rating: 3)

taylor = Artist.create!(
  email: 'taylor.swift@example.com',
  first_name: 'Taylor',
  last_name: 'Swift'
)

Item.create!(
  [
    {
      title: "Red (Taylor's Version)",
      description: 'Loving him is like driving a new Maserati down a dead-end street...',
      artist: taylor,
      image_url: 'https://static.wikia.nocookie.net/taylor-swift/images/9/93/Red_%28Taylor%27s_Version%29.jpeg/revision/latest/scale-to-width-down/1000?cb=20210618181243'
    },
    {
      title: "All Too Well (Taylor's Version)",
      description: 'It was rare, I was there, I remember it all too well',
      artist: taylor,
      image_url: 'https://static.wikia.nocookie.net/taylor-swift/images/9/93/Red_%28Taylor%27s_Version%29.jpeg/revision/latest/scale-to-width-down/1000?cb=20210618181243'
    },
    {
      title: "We Are Never Ever Getting Back Together (Taylor's Version)",
      description: 'You go talk to your friends, talk to my friends, talk to me',
      artist: taylor,
      image_url: 'https://static.wikia.nocookie.net/taylor-swift/images/9/93/Red_%28Taylor%27s_Version%29.jpeg/revision/latest/scale-to-width-down/1000?cb=20210618181243'
    },
    {
      title: "Begin Again (Taylor's Version)",
      description: 'But on a Wednesday in a café, I watched it begin again',
      artist: taylor,
      image_url: 'https://static.wikia.nocookie.net/taylor-swift/images/9/93/Red_%28Taylor%27s_Version%29.jpeg/revision/latest/scale-to-width-down/1000?cb=20210618181243'
    }
  ]
)

pizza_1 = Pizza.create!(name: 'Meat Pizza', vegan: false)
pizza_2 = Pizza.create!(name: 'Pepperoni Pizza', vegan: false)
pizza_3 = Pizza.create!(name: 'Cheese Pizza', vegan: false)
pizza_4 = Pizza.create!(name: 'Vegan Pizza', vegan: true)
pizza_5 = Pizza.create!(name: 'Salad Pizza', vegan: true)

pizza_1.ingredients.create!(name: 'ingredient_1')
pizza_2.ingredients.create!(name: 'ingredient_2')
pizza_3.ingredients.create!(name: 'ingredient_3')
pizza_4.ingredients.create!(name: 'ingredient_4')
pizza_5.ingredients.create!(name: 'ingredient_5')

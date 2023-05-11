require 'rails_helper'

RSpec.describe 'Restaurants API', type: :request do
  describe 'GET /restaurants' do
    context 'when the sort parameter is given' do
      it 'returns sorted restaurants' do
        restaurant_1 = Restaurant.create(name: 'Ziggie', address: '123 Main St')
        restaurant_2 = Restaurant.create(name: 'Biggie', address: '456 Elm St')
        expected_response_body = {
          'data' =>
            [
              {
                'id' => restaurant_2.id.to_s,
                'type' => 'restaurants',
                'links' => { 'self' => "http://www.example.com/restaurants/#{restaurant_2.id}" },
                'attributes' => { 'name' => restaurant_2.name.to_s, 'address' => restaurant_2.address.to_s },
                'relationships' => {
                  'dishes' => {
                    'links' => {
                      'self' => "http://www.example.com/restaurants/#{restaurant_2.id}/relationships/dishes",
                      'related' => "http://www.example.com/restaurants/#{restaurant_2.id}/dishes"
                    }
                  }
                }
              },
              {
                'id' => restaurant_1.id.to_s,
                'type' => 'restaurants',
                'links' => { 'self' => "http://www.example.com/restaurants/#{restaurant_1.id}" },
                'attributes' => { 'name' => restaurant_1.name.to_s, 'address' => restaurant_1.address.to_s },
                'relationships' => {
                  'dishes' => {
                    'links' => {
                      'self' => "http://www.example.com/restaurants/#{restaurant_1.id}/relationships/dishes",
                      'related' => "http://www.example.com/restaurants/#{restaurant_1.id}/dishes"
                    }
                  }
                }
              }
            ]
        }

        get '/api/json_api/restaurants?sort=name'

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(expected_response_body)
      end
    end
  end

  describe 'GET /restaurants/:id' do
    context 'when relation inclusion requested' do
      it 'returns a specific restaurant with associated dishes' do
        restaurant = Restaurant.create(name: 'Restaurant A', address: '123 Main St')
        dish = restaurant.dishes.create(name: 'Dish 1', rating: 4)
        expected_response_body = {
          'data' =>
            {
              'id' => restaurant.id.to_s,
              'type' => 'restaurants',
              'links' => { 'self' => "http://www.example.com/restaurants/#{restaurant.id}" },
              'attributes' => { 'name' => restaurant.name.to_s, 'address' => restaurant.address.to_s },
              'relationships' => {
                'dishes' => {
                  'links' => {
                    'self' => "http://www.example.com/restaurants/#{restaurant.id}/relationships/dishes",
                    'related' => "http://www.example.com/restaurants/#{restaurant.id}/dishes"
                  },
                  'data' => [{ 'type' => 'dishes', 'id' => dish.id.to_s }]
                }
              }
            },
          'included' =>
            [
              {
                'id' => dish.id.to_s,
                'type' => 'dishes',
                'links' => { 'self' => "http://www.example.com/dishes/#{dish.id}" },
                'attributes' => { 'name' => dish.name.to_s, 'rating' => dish.rating },
                'relationships' => {
                  'restaurant' => {
                    'links' => {
                      'self' => "http://www.example.com/dishes/#{dish.id}/relationships/restaurant",
                      'related' => "http://www.example.com/dishes/#{dish.id}/restaurant"
                    },
                    'data' => { 'type' => 'restaurants', 'id' => restaurant.id.to_s }
                  }
                }
              }
            ]
        }

        get "/api/json_api/restaurants/#{restaurant.id}?include=dishes"

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(expected_response_body)
      end
    end

    context 'when no restaurant is found' do
      it 'returns an error if the restaurant is not found' do
        expected_response_body = {
          'errors' => [
            {
              'title' => 'Record not found', 'detail' => 'The record identified by 999 could not be found.',
              'code' => '404',
              'status' => '404'
            }
          ]
        }

        get '/api/json_api/restaurants/999'

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_body).to eq(expected_response_body)
      end
    end
  end

  describe 'POST /restaurants' do
    it 'creates a new restaurant with associated dishes', :aggregate_failures do
      creation_data = {
        data: {
          type: 'restaurants',
          attributes: {
            name: 'Ziggie',
            address: '123 Main St'
          }
        }
      }

      expect do
        post '/api/json_api/restaurants',
             params: creation_data.to_json,
             headers: { 'Content-Type' => 'application/vnd.api+json' }
      end.to change(Restaurant, :count).from(0).to(1)

      response_body = JSON.parse(response.body)
      created_restaurant = Restaurant.first
      expected_response_body = {
        'data' =>
          {
            'id' => created_restaurant.id.to_s,
            'type' => 'restaurants',
            'links' => { 'self' => "http://www.example.com/restaurants/#{created_restaurant.id}" },
            'attributes' => {
              'name' => created_restaurant.name.to_s,
              'address' => created_restaurant.address.to_s
            },
            'relationships' => {
              'dishes' => {
                'links' => {
                  'self' => "http://www.example.com/restaurants/#{created_restaurant.id}/relationships/dishes",
                  'related' => "http://www.example.com/restaurants/#{created_restaurant.id}/dishes"
                }
              }
            }
          }
      }

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(expected_response_body)
    end

    context 'when error' do
      it 'returns an error if the restaurant creation fails' do
        creation_data = {
          data: {
            type: 'restaurants',
            attributes: {
              name: 'Ziggie',
              address: '123 Main St'
            }
          }
        }
        expected_response_body = {
          'errors' => [
            {
              'title' => 'Unsupported media type',
              'detail' => "All requests that create or update must use the 'application/vnd.api+json' " \
                          "Content-Type. This request specified 'application/json'.",
              'code' => '415',
              'status' => '415'
            }
          ]
        }

        post '/api/json_api/restaurants',
             params: creation_data.to_json,
             headers: { 'Content-Type' => 'application/json' }

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:unsupported_media_type)
        expect(response_body).to eq(expected_response_body)
      end
    end
  end

  describe 'PATCH /restaurants/:id' do
    it 'updates a specific restaurant' do
      restaurant = Restaurant.create(name: 'Restaurant A', address: '123 Main St')
      update_data = {
        data: {
          type: 'restaurants',
          id: restaurant.id.to_s,
          attributes: {
            name: 'Updated Restaurant'
          }
        }
      }
      expected_response_body = {
        'data' =>
          {
            'id' => restaurant.id.to_s,
            'type' => 'restaurants',
            'links' => { 'self' => "http://www.example.com/restaurants/#{restaurant.id}" },
            'attributes' => { 'name' => 'Updated Restaurant', 'address' => restaurant.address.to_s },
            'relationships' => {
              'dishes' => {
                'links' => {
                  'self' => "http://www.example.com/restaurants/#{restaurant.id}/relationships/dishes",
                  'related' => "http://www.example.com/restaurants/#{restaurant.id}/dishes"
                }
              }
            }
          }
      }

      patch "/api/json_api/restaurants/#{restaurant.id}",
            params: update_data.to_json,
            headers: { 'Content-Type' => 'application/vnd.api+json' }

      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_body).to eq(expected_response_body)
    end
  end

  describe 'DELETE /restaurants/:id' do
    it 'deletes a specific restaurant' do
      restaurant = Restaurant.create(name: 'Restaurant A', address: '123 Main St')

      expect do
        delete "/api/json_api/restaurants/#{restaurant.id}"
      end.to change { Restaurant.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

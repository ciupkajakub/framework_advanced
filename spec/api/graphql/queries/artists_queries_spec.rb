require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do
  describe 'Artist API' do
    describe 'artists query' do
      it 'returns all artists with their associated items' do
        artist_1 = Artist.create(first_name: 'John', last_name: 'Doe', email: 'john@doe.com')
        artist_2 = Artist.create(first_name: 'James', last_name: 'Bond', email: 'james@bond.com')
        item_1 = artist_1.items.create(title: 'some title 1', description: 'some desc 1', image_url: 'some_url_1.com')
        item_2 = artist_2.items.create(title: 'some title 2', description: 'some desc 2', image_url: 'some_url_2.com')
        query = <<~GQL
          query {
            artists {
              id
              firstName
              lastName
              email
              items {
                id
                title
                description
              }
            }
          }
        GQL
        expected_response_body = {
          'data' =>
            {
              'artists' =>
                [
                  {
                    'id' => artist_1.id.to_s,
                    'firstName' => artist_1.first_name,
                    'lastName' => artist_1.last_name,
                    'email' => artist_1.email,
                    'items' =>
                      [
                        {
                          'id' => item_1.id.to_s,
                          'title' => item_1.title,
                          'description' => item_1.description
                        }
                      ]
                  },
                  {
                    'id' => artist_2.id.to_s,
                    'firstName' => artist_2.first_name,
                    'lastName' => artist_2.last_name,
                    'email' => artist_2.email,
                    'items' => [
                      {
                        'id' => item_2.id.to_s,
                        'title' => item_2.title,
                        'description' => item_2.description
                      }
                    ]
                  }
                ]
            }
        }
        post '/graphql', params: { query: }

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(expected_response_body)
      end
    end

    describe 'artist query' do
      it 'returns a specific artist with their associated items' do
        artist = Artist.create(first_name: 'James', last_name: 'Bond', email: 'james@bond.com')
        item_1 = artist.items.create(title: 'some title 1', description: 'some desc 1', image_url: 'some_url_1.com')
        item_2 = artist.items.create(title: 'some title 2', description: 'some desc 2', image_url: 'some_url_2.com')
        query = <<~GQL
          query($id: ID!) {
            artist(id: $id) {
              id
              firstName
              lastName
              email
              items {
                id
                title
                description
              }
            }
          }
        GQL
        expected_response_body = {
          'data' =>
            {
              'artist' =>
                {
                  'id' => artist.id.to_s,
                  'firstName' => artist.first_name,
                  'lastName' => artist.last_name,
                  'email' => artist.email,
                  'items' =>
                    [
                      {
                        'id' => item_1.id.to_s,
                        'title' => item_1.title,
                        'description' => item_1.description
                      },
                      {
                        'id' => item_2.id.to_s,
                        'title' => item_2.title,
                        'description' => item_2.description
                      }
                    ]
                }
            }
        }

        post '/graphql', params: { query:, variables: { id: artist.id } }

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(expected_response_body)
      end
    end
  end
end

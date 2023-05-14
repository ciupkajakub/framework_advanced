require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do
  describe 'Artist API' do
    describe 'createArtist mutation' do
      context 'when success' do
        it 'creates a new artist', :aggregate_failures do
          first_name = 'John'
          last_name = 'Wick'
          email = 'john@wick.com'
          query = <<~GQL
            mutation {
              createArtist(input: {
                firstName: "#{first_name}"
                lastName: "#{last_name}"
                email: "#{email}"
              }) {
                artist {
                  id
                  firstName
                  lastName
                  email
                }
                errors
              }
            }
          GQL

          expect do
            post '/graphql', params: { query: }
          end.to change(Artist, :count).from(0).to(1)

          artist = Artist.first
          expected_response_body = {
            'data' => {
              'createArtist' => {
                'artist' => {
                  'id' => artist.id.to_s,
                  'firstName' => first_name,
                  'lastName' => last_name,
                  'email' => email
                },
                'errors' => []
              }
            }
          }
          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
        end
      end

      context 'when invalid parameters are passed' do
        it 'does not save an Artist and returns the errors', :aggregate_failures do
          query = <<~GQL
            mutation {
              createArtist(input: {
                firstName: ""
                lastName: ""
                email: ""
              }) {
                artist {
                  id
                  firstName
                  lastName
                  email
                }
                errors
              }
            }
          GQL
          expected_response_body = {
            'data' => { 'createArtist' => nil },
            'errors' =>
              [
                { 'message' => 'First name can’t be blank, Last name can’t be blank, Email can’t be blank',
                  'locations' => [{ 'line' => 2, 'column' => 3 }],
                  'path' => ['createArtist'] }
              ]
          }

          expect do
            post '/graphql', params: { query: }
          end.not_to change(Artist, :count)

          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
        end
      end
    end

    describe 'updateArtist mutation' do
      context 'when success' do
        it 'updates an existing artist', :aggregate_failures do
          artist = Artist.create(first_name: 'Beny', last_name: 'Doe', email: 'beny@doe.com')
          first_name = 'John'
          last_name = 'Wick'
          email = 'john@wick.com'
          query = <<~GQL
            mutation {
              updateArtist(input: {
                id: "#{artist.id}"
                firstName: "#{first_name}"
                lastName: "#{last_name}"
                email: "#{email}"
              }) {
                artist {
                  id
                  firstName
                  lastName
                  email
                }
                errors
              }
            }
          GQL
          expected_response_body = {
            'data' => {
              'updateArtist' => {
                'artist' => {
                  'id' => artist.id.to_s, 'firstName' => 'John', 'lastName' => 'Wick', 'email' => 'john@wick.com'
                },
                'errors' => []
              }
            }
          }

          post '/graphql', params: { query: }

          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
          expect(artist.reload).to have_attributes(first_name:, last_name:, email:)
        end
      end

      context 'when invalid params are passed' do
        it 'returns the errors', :aggregate_failures do
          artist = Artist.create(first_name: 'Beny', last_name: 'Doe', email: 'beny@doe.com')

          query = <<~GQL
            mutation {
              updateArtist(input: {
                id: "#{artist.id}"
                firstName: ""
                lastName: ""
                email: ""
              }) {
                artist {
                  id
                  firstName
                  lastName
                  email
                }
                errors
              }
            }
          GQL
          expected_response_body = {
            'data' => { 'updateArtist' => nil },
            'errors' =>
              [
                { 'message' => 'First name can’t be blank, Last name can’t be blank, Email can’t be blank',
                  'locations' => [{ 'line' => 2, 'column' => 3 }],
                  'path' => ['updateArtist'] }
              ]
          }

          post '/graphql', params: { query: }

          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
        end
      end
    end

    describe 'deleteArtist mutation' do
      context 'when success' do
        it 'deletes an existing artist' do
          artist = Artist.create(first_name: 'Beny', last_name: 'Doe', email: 'beny@doe.com')
          query = <<~GQL
            mutation {
              deleteArtist(input: {
                id: "#{artist.id}"
              }) {
                id
                errors
              }
            }
          GQL
          expected_response_body = { 'data' => { 'deleteArtist' => { 'id' => artist.id.to_s, 'errors' => [] } } }

          expect do
            post '/graphql', params: { query: }
          end.to change(Artist, :count).from(1).to(0)

          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
        end
      end

      context 'when record not found' do
        it 'returns the errors', :aggregate_failures do
          query = <<~GQL
            mutation {
              deleteArtist(input: {
                id: "1"
              }) {
                id
                errors
              }
            }
          GQL
          expected_response_body = {
            'data' => {
              'deleteArtist' => { 'id' => nil, 'errors' => ['Artist with id: 1 not found'] }
            }
          }

          post '/graphql', params: { query: }

          response_body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(response_body).to eq(expected_response_body)
        end
      end
    end
  end
end

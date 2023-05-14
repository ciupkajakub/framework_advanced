class Types::QueryType < Types::BaseObject
  # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
  include GraphQL::Types::Relay::HasNodeField
  include GraphQL::Types::Relay::HasNodesField

  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :artists, [Types::ArtistType], null: false, description: 'Return a list of artists'
  field :artist, Types::ArtistType, null: false, description: 'Return a specific artist' do
    argument :id, ID, required: true
  end
  field :items, [Types::ItemType], null: false, description: 'Return a list of items'

  def artists
    Artist.all
  end

  def artist(id:)
    Artist.find(id)
  end

  def items
    Item.all
  end
end

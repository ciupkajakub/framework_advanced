class Types::ArtistType < Types::BaseObject
  field :id, ID, null: false
  field :first_name, String, null: false
  field :last_name, String, null: false
  field :email, String, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  field :items, [Types::ItemType], null: true
  field :items_count, Integer, null: true

  def full_name
    [object.first_name, object.last_name].compact.join
  end

  def items_count
    object.items.size
  end
end

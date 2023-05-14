class Mutations::DeleteArtistMutation < Mutations::BaseMutation
  argument :id, ID, required: true

  field :id, ID, null: true
  field :errors, [String], null: false

  def resolve(id:)
    artist = Artist.find(id)

    artist.delete
    { id:, errors: [] }
  rescue ActiveRecord::RecordNotFound => _e
    { id: nil, errors: ["Artist with id: #{id} not found"] }
  end
end

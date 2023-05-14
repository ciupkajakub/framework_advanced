class Mutations::UpdateArtistMutation < Mutations::BaseMutation
  argument :id, ID, required: true
  argument :first_name, String, required: false
  argument :last_name, String, required: false
  argument :email, String, required: false

  field :artist, Types::ArtistType, null: true
  field :errors, [String], null: false

  def resolve(id:, **inputs)
    artist = Artist.find(id)

    if artist.update(inputs.to_h)
      { artist:, errors: [] }
    else
      raise GraphQL::ExecutionError, artist.errors.full_messages.join(', ')
    end
  end
end

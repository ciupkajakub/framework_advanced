class Mutations::CreateArtistMutation < Mutations::BaseMutation
  argument :first_name, String, required: true
  argument :last_name, String, required: true
  argument :email, String, required: true

  field :artist, Types::ArtistType, null: true
  field :errors, [String], null: false

  def resolve(inputs = {})
    artist = Artist.new(inputs.to_h)

    if artist.save
      { artist:, errors: [] }
    else
      raise GraphQL::ExecutionError, artist.errors.full_messages.join(', ')
    end
  end
end

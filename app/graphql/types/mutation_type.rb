class Types::MutationType < Types::BaseObject
  field :create_artist, mutation: Mutations::CreateArtistMutation
  field :delete_artist, mutation: Mutations::DeleteArtistMutation
  field :update_artist, mutation: Mutations::UpdateArtistMutation
end

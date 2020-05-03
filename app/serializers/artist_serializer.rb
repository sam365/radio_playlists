# frozen_string_literal: true

# serializer for atists
class ArtistSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :image
end
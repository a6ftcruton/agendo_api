#configured to use json_api adapter - see config/initializers/ams

class TagSerializer < ActiveModel::Serializer
  has_many :todos

  attributes :id, :name
end

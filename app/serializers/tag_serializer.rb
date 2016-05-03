#configured to use json_api adapter - see config/initializers/ams

class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
end

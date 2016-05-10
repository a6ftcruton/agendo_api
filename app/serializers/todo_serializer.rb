#configured to use json_api adapter - see config/initializers/ams

class TodoSerializer < ActiveModel::Serializer
  has_many :tags

  attributes :id, :title, :complete
end

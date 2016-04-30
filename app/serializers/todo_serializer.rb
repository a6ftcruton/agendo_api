#configured to use json_api adapter - see config/initializers/ams

class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :complete
end

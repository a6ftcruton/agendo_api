api_mime_types = %W(
  application/vnd.api+json
  text/x-json
  application/json
)

# Mime::Type.unregister :json
Mime::Type.register 'application/json', :json, api_mime_types

parsers = Rails::VERSION::MAJOR >= 5 ? ActionDispatch::Http::Parameters : ActionDispatch::ParamsParser
media_type = Mime::Type.lookup(ActiveModelSerializers::Jsonapi::MEDIA_TYPE)

# Proposal: should actually deserialize the JSON API params
# to the hash format expected by `ActiveModel::Serializers::JSON`
# actionpack/lib/action_dispatch/http/parameters.rb
parsers::DEFAULT_PARSERS[media_type] = lambda do |body|
  data = JSON.parse(body)
  data = { :_json => data } unless data.is_a?(Hash)

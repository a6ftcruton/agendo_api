require 'rails_helper'

RSpec.describe TodoSerializer, :type => :serializer do

  # Pretty Print the Serialized result:
  # puts JSON.pretty_generate(JSON.parse(serialization.to_json))

  context 'adhere to json:api spec' do
    let(:resource) { build(:todo) }

    let(:serializer) { TodoSerializer.new(resource) }
    let(:serialization) { ActiveModel::Serializer::Adapter.create(serializer) }
    let(:serialized_response) { JSON.parse(serialization.to_json) }

    it 'has a top-level "data" key' do
      expect(serialized_response.keys).to eq(%w(data))
    end

    it 'data key can access "type", "id", and "attributes" keys' do
      expected_keys = %w(attributes id type)

      expect(serialized_response["data"].keys.sort).to eq(expected_keys)
    end

    it 'contains "title" and "complete" as attributes' do
      expected_attrs = %w(complete title)

      expect(serialized_response["data"]["attributes"].keys.sort).to eq(expected_attrs)
    end

    #TODO - test relationships/included
    #
  end
end

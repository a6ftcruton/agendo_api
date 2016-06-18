require 'rails_helper'

RSpec.describe Api::V1::TagsController, type: :controller do
  let(:parsed_response) { JSON.parse(response.body) }
  let(:data) { JSON.parse(response.body)["data"] }
  let(:attributes) { JSON.parse(response.body)["data"]["attributes"] }

  describe '#index' do
    it 'returns all tags' do
      tags = create_list(:tag, 5)

      get :index,
        format: :json

      expect(response.status).to eq(200)
      expect(data.length).to eq(tags.length)
    end
  end

  describe '#show' do
    it 'returns record serialized to json:api spec' do
      tag = create(:tag)
      pluralized_class_name = tag.class.name.downcase.pluralize

      get :show,
        id: tag.id,
        format: :json

      expect(response.status).to eq(200)
      expect(data["id"].to_i).to eq(tag.id)
      expect(data["type"]).to eq(pluralized_class_name)
      expect(attributes["name"]).to eq(tag.name)
    end

    it 'returns a 404 if no record found' do
      get :show,
        id: 666, 
        format: :json

      expect(response.status).to eq(404)
      expect(response.body).to be_empty
    end
  end

  describe '#create' do
    it 'creates a record with the given name' do
      name = "Chores"
      json_params = 
        { type: "tags",
          attributes: {name: name}
        }

      expect{
        post :create, 
          data: json_params
      }.to change(Tag, :count).by(1)

      expect(Tag.last.name).to eq(name)
    end

    it 'fails to create a tag when name blank or empty' do
      name = ""
      json_params = 
        { type: "tags",
          attributes: {name: name} 
        }

      post :create,
        data: json_params

      errors = parsed_response["errors"].first
      expect(errors["status"]).to eq(422)
      expect(errors["detail"]).to eq("Name can't be blank")
    end
  end

  describe '#update' do
    it 'updates name field for an existing tag' do
      tag         = create(:tag, name: "Work stuff")
      new_name    = "Party essentials"
      json_params = 
        { type: "tags",
          id: tag.id,
          attributes: {name: new_name}
        }

      patch :update,
        id: tag.id,
        data: json_params

      tag.reload

      expect(tag.name).to eq(new_name)
      #Todo - error response for multiple errors should match json spec
      #Todo - refactor base controller response methods to be more flexible (error_response, empty_response)
    end
  end

  describe '#destroy' do
    let!(:tag) { create :tag, name: "Weekend" }

    it 'deletes the record' do
      expect{
        delete :destroy, id: tag.id
      }.to change(Tag, :count).by(-1)
    end

    it 'returns and empty response' do
      delete :destroy, id: tag.id

      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
    #tag - after assigning relationships tags/tags, ensure that destroy removes the join record
  end
  describe '#destroy with tags' do
    it 'deletes a record and associated tags' do
      tag  = create(:tag, name: "tester")

      #create a tagging record
      todo = create(:todo, title: "howdy", tag_ids: [tag.id])

      delete :destroy, id: tag.id

      expect(response.status).to eq(204)
      expect(Tag.count).to eq(0)
      expect(Tagging.count).to eq(0)
    end
  end
end

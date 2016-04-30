require 'rails_helper'

RSpec.describe Api::V1::TodosController, type: :controller do

  let(:parsed_response) { JSON.parse(response.body) }
  let(:data) { JSON.parse(response.body)["data"] }
  let(:attributes) { JSON.parse(response.body)["data"]["attributes"] }

  describe '#index' do
    it 'returns all todos' do
      todos = create_list(:todo, 5)

      get :index,
        format: :json

      expect(response.status).to eq(200)
      expect(data.length).to eq(todos.length)
    end
  end

  describe '#show' do
    it 'returns record serialized to json:api spec' do
      todo = create(:todo)
      pluralized_class_name = todo.class.name.downcase.pluralize

      get :show,
        id: todo.id,
        format: :json

      expect(response.status).to eq(200)
      expect(data["id"].to_i).to eq(todo.id)
      expect(data["type"]).to eq(pluralized_class_name)
      expect(attributes["title"]).to eq(todo.title)
    end

    it 'returns a 404 if no record found' do
      get :show,
        id: 999, 
        format: :json

      expect(response.status).to eq(404)
      expect(response.body).to be_empty
    end
  end
end

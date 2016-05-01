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

  describe '#create' do
    it 'creates a record with the given title' do
      title = "My new todo"

      expect{
        post :create,
          todo: { title: title },
          format: :json
      }.to change(Todo, :count).by(1)

      expect(Todo.last.title).to eq(title)
    end

    it 'fails to create a todo when title blank or empty' do
      post :create,
        todo: { title: "" },
        format: :json

      errors = parsed_response["errors"].first
      expect(errors["status"]).to eq(422)
      expect(errors["detail"]).to eq("Title can't be blank")
    end
  end

  describe '#update' do
    it 'updates title field for an existing todo' do
      todo = create(:todo, title: "Rough draft")
      new_title = "Final draft"

      patch :update,
        id: todo.id,
        todo: {
          title: new_title,
          complete: true
        }

      todo.reload

      expect(todo.title).to eq(new_title)
      expect(todo.complete).to eq(true)
      #TODO - error response for multiple errors should match json spec
      #TODO - refactor base controller response methods to be more flexible (error_response, empty_response)
    end
  end

  describe '#destroy' do
    let!(:todo) { create :todo, title: "Please do not delete me" }

    it 'deletes the record' do
      expect{
        delete :destroy, id: todo.id
      }.to change(Todo, :count).by(-1)
    end

    it 'returns and empty response' do
      delete :destroy, id: todo.id

      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
    #TODO - after assigning relationships tags/todos, ensure that destroy removes the join record
  end
end

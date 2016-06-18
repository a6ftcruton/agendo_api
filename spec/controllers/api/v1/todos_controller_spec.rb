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
      json_params = 
        { type: "todos",
          attributes: { title: title }
        }

      expect{  
        post :create,
          data: json_params
      }.to change(Todo, :count).by(1)

      expect(Todo.last.title).to eq(title)
    end

    it 'fails to create a todo when title blank or empty' do
      json_params = 
        { type: "todos",
          attributes: { title: "" }
        }

      post :create,
        data: json_params

      errors = parsed_response["errors"].first
      expect(errors["status"]).to eq(422)
      expect(errors["detail"]).to eq("Title can't be blank")
    end
  end

  describe '#update' do
    it 'updates title and complete field for an existing todo' do
      todo = create(:todo, title: "Rough draft")
      new_title = "Final draft"
      json_params = 
        { id: todo.id,
          type: "todos",
          attributes: {
            title: "#{new_title}",
            complete: true
          }
        }

      patch :update, 
        id: todo.id,
        data: json_params

      todo.reload

      expect(todo.title).to eq(new_title)
      expect(todo.complete).to eq(true)
      #TODO - error response for multiple errors should match json spec
      #TODO - refactor base controller response methods to be more flexible (error_response, empty_response)
    end

    context 'relationships' do
      it 'adds a tag' do
        tag  = create(:tag, name: "edit-tag")
        todo = create(:todo, title: "has relationship", tag_ids: [])
        json_params =
          { id: todo.id,
            type: "todos",
            attributes: {
              title: "hello",
              complete: true
            },
            relationships: {
              "tags": {
                "data": [
                  {type: "tags", id: tag.id}
                ]
              }
            }
          }

        patch :update,
          id: todo.id,
          data: json_params

        todo.reload

        expect(response.status).to eq(204)
        expect(todo.tags.count).to eq(1)
      end

      it 'removes an existing tag' do
        tag  = create(:tag, name: "edit-tag")
        todo = create(:todo, title: "has relationship", tag_ids: [tag.id])
        json_params =
          { id: todo.id,
            type: "todos",
            attributes: {
              title: "hello",
              complete: true
            },
            relationships: {
              "tags": {
                "data": []
              }
            }
          }

        patch :update,
          id: todo.id,
          data: json_params

        todo.reload

        expect(todo.tags.count).to eq(0)
      end

      it 'removes the correct tag existing tag' do
        keep_tag    = create(:tag, name: "keep")
        remove_tag  = create(:tag, name: "remove")
        todo        = create(:todo, title: "has relationship", tag_ids: [keep_tag.id, remove_tag.id])
        json_params =
          { id: todo.id,
            type: "todos",
            attributes: {
              title: "hello",
              complete: true
            },
            relationships: {
              "tags": {
                "data": [
                  {type: "tags", id: keep_tag.id}
                ]
              }
            }
          }

        patch :update,
          id: todo.id,
          data: json_params

        todo.reload

        expect(response.status).to eq(204)
        expect(todo.tags.count).to eq(1)
        expect(todo.tags.first.name).to eq("keep")
      end

      it 'debugging AMS bad deserialization of empty params' do
        tag  = create(:tag, name: "edit-tag")
        todo = create(:todo, title: "has relationship", tag_ids: [tag.id])
        json_params = 
          {"id":"#{todo.id}",
           "type":"todos",
           "attributes": {"title":"y","complete":false},
           "relationships": {"tags":{"data":[]}}}

        patch :update,
          id: todo.id,
          data: json_params

        todo.reload

        expect(todo.tags.count).to eq(0)
      end
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
  end
    #TODO - after assigning relationships tags/todos, ensure that destroy removes the join record
  describe '#destroy with tags' do
    it 'deletes a record and associated tags' do
      tag  = create(:tag, name: "tester")
      todo = create(:todo, title: "howdy", tag_ids: [tag.id])

      delete :destroy, id: todo.id

      expect(response.status).to eq(204)
      expect(Todo.count).to eq(0)
      expect(Tagging.count).to eq(0)
    end
  end
end

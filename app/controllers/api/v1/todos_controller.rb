class Api::V1::TodosController < Api::V1::BaseController
  before_filter :find_todos, only: %i(index)
  before_filter :find_todo, only: %i(show update destroy)

  def index
    render json: @todos
  end

  def show
    if @todo.present?
      render json: @todo
    else
      record_not_found
    end
  end

  # def create
  # end

  # def update
  # end

  # def destroy
  # end

  private

  def find_todos
    @todos = Todo.all 
  end

  def find_todo
    @todo = Todo.find_by(id: params[:id])
  end

end

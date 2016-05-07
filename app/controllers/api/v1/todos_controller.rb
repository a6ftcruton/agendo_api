class Api::V1::TodosController < Api::V1::BaseController
  before_filter :log_request, only: %i(index show create update destroy)
  before_filter :find_todos, only: %i(index)
  before_filter :find_todo, only: %i(show update destroy)

  def index
    render json: @todos
  end

  def show
    if @todo.present?
      render json: @todo
    else
      empty_response(404)
    end
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: @todo
    else
      render json: errors_hash(422, @todo.errors.full_messages.join)
    end
  end

  def update
    if @todo.update(todo_params)
      empty_response(204)
    else
      render json: errors_hash(422, @todo.errors.full_messages.join)
    end
  end

  def destroy
    empty_response(204) if @todo.destroy!
  end

  private
  def log_request
    puts "\n"
    puts "*" * 40
    puts "REQUEST PARAMS == "
    puts "#{params.inspect}"
    puts "*" * 40
    puts "\n"
  end

  def find_todos
    @todos = Todo.all 
  end

  def find_todo
    binding.pry
    @todo = Todo.find_by(id: params[:id])
  end

  def todo_params
    params.require(:data)
          .require(:attributes)
          .permit(:title, :complete)
  end
end

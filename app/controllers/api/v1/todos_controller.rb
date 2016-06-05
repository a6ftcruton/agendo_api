class Api::V1::TodosController < Api::V1::BaseController
  before_filter :massage_params_for_jsonapi, only: %i(update)
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
    puts "todo before update\n\n #{@todo.inspect}"
    puts "todo.tags before update\n\n #{@todo.tags.inspect}"
    puts "\n\ntodo_update_params.inspect -->  #{todo_update_params.inspect}"
    if @todo.update!(todo_update_params)
      puts "todo after update\n\n #{@todo.inspect}"
      puts "todo.tags after update\n\n #{@todo.tags.inspect}"
      empty_response(204)
    else
      render json: errors_hash(422, @todo.errors.full_messages.join)
    end
  end

  def destroy
    empty_response(204) if @todo.destroy!
  end

  private
  def massage_params_for_jsonapi
    let tagKey = [:data][:relationships][:data]
    puts "\n"
    puts "*" * 40
    puts "tagKey"
    puts tagKey
    puts "*" * 40
    puts "\n"
    tagKey = [] if tagKey.nil?
  end

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
    @todo = Todo.find_by(id: params[:id])
  end

  def todo_params
    params.require(:data)
          .require(:attributes)
          .permit(:title, :complete)
  end

  def todo_update_params
    # puts "\n\nparams === #{params.inspect}"
    # params.require(:data)
    #       .permit(:relationships)
    #       .permit(:attributes)
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params)
  end
end

class Api::V1::TagsController < Api::V1::BaseController
  before_filter :find_tags, only: %i(index)
  before_filter :find_tag, only: %i(show update destroy)

  def index
    render json: @tags
  end

  def show
    if @tag.present?
      render json: @tag
    else
      empty_response(404)
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: errors_hash(422, @tag.errors.full_messages.join)
    end
  end

  def update
    if @tag.update(tag_params)
      empty_response(204)
    else
      render json: errors_hash(422, @tag.errors.full_messages.join)
    end
  end

  def destroy
    empty_response(204) if @tag.destroy!
  end

  private

  def find_tags
    @tags = Tag.all 
  end

  def find_tag
    @tag = Tag.find_by(id: params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end

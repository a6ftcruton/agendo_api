class Api::V1::TagsController < ApplicationController
  def index
    render nothing: true, status 201
  end
end

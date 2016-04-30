class Api::V1::BaseController < ApplicationController

  def record_not_found
    render nothing: true, status: 404
  end
end

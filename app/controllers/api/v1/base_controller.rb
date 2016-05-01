class Api::V1::BaseController < ApplicationController

  def record_not_found
    empty_response(404)
  end

  def empty_response(status)
    render nothing: true, status: status
  end

  def errors_hash(status, message)
    #TODO - jsonapi spec - each error gets it's own hash
    #create error code lookup table/hash where values are message w/ placedholder?
    # SUCCESS = { 201: ... }
    # ERRORS = { 404: "Record not found", 422: "${model} could not be processed" }
    # errors: [status: status, title: ERRORS["${status}", detail: model.errors.full_messages.join]]
    # write a ruby gem for jsonapi compliant error responses?
    { errors: [
        status: status,
        detail: message 
      ]
    }
  end
end

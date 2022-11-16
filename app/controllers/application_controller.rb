class ApplicationController < ActionController::API
  before_action :ensure_json_request

  def ensure_json_request
    return if /vnd\.api\+json/.match?(request.headers['accept'])

    render nothing: true, status: :not_acceptable
  end
end

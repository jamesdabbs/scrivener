class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :require_teamwork_api_key!

  def teamwork
    if params[:token] == ENV["TEAMWORK_HOOK_SECRET"]
      payload = {
        params: params.to_h,
        form:   params[:form],
        raw:    request.raw_post
      }
      hook = Hook.create! source: request.remote_ip, payload: payload
      hook.perform!
      head :ok
    else
      head :bad_request
    end
  end
end

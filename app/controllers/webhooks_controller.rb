class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :require_teamwork_api_key!

  def teamwork
    unless params[:token] == ENV["TEAMWORK_HOOK_SECRET"]
      head :bad_request
      return
    end

    begin
      payload = {
        params: params.to_h,
        form:   params[:form],
        raw:    request.raw_post
      }
      hook = Hook.create! source: request.remote_ip, payload: payload
      hook.perform!
    rescue => e
      Rails.logger.info "Error in webhook: #{e}"
    end

    head :ok
  end
end

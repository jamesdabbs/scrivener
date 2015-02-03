class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :require_teamwork_api_key!

private

  def require_teamwork_api_key!
    if current_user && current_user.teamwork_api_key.nil?
      session[:post_teamwork_api_key_return] = request.path
      redirect_to new_teamwork_api_key_path
    end
  end
end

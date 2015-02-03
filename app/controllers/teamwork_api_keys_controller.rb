class TeamworkApiKeysController < ApplicationController
  skip_before_filter :require_teamwork_api_key!

  def new
  end

  def create
    current_user.update teamwork_api_key: params[:teamwork_api_key]
    # TODO: validate key against teamwork, more robust job system
    SyncJob.new.async.perform current_user.id
    flash[:success] = "Added a Teamwork key. Data should sync momentarily. Try refreshing."
    redirect_to session.delete(:post_teamwork_api_key_return) || journals_path
  end
end

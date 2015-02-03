class JournalsController < ApplicationController
  def index
    @journals = Journal.all.includes :author, :category
  end

  def sync
    Journal.sync! current_user.teamwork
    redirect_to :back
  end
end

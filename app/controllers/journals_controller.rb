class JournalsController < ApplicationController
  def index
    @journals = Journal.all.includes :author, :category
    %i(author category week).each do |col|
      @journals = @journals.where(col => params[col]) if params[col]
    end
  end

  def sync
    Journal.sync! current_user.teamwork
    redirect_to :back
  end
end

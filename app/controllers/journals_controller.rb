class JournalsController < ApplicationController
  def index
    @journals = Journal.all.includes :author, :category
    %i(author category week).each do |col|
      @journals = @journals.where(col => params[col]) if params[col]
    end
  end

  def sync
    [Author, Category, Journal].each do |klass|
      klass.sync! current_user.teamwork
    end
    redirect_to :back
  end

  def push_category
    journal = Journal.find params[:id]
    journal.push_category_to_teamwork! current_user.teamwork
    redirect_to :back
  end
end

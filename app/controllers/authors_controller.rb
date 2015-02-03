class AuthorsController < ApplicationController
  def index
    @authors = Author.all
    @categories = Category.all
  end

  def update
    @author = Author.find params[:id]
    @author.update update_params
    redirect_to :back
  end

private

  def update_params
    params.require(:author).permit(:default_category_id)
  end
end

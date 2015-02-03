class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!

  def root
    redirect_to journals_path if current_user
  end
end

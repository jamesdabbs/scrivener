class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:github]

  validates_presence_of :name, :gh_username, :gh_token, :gh_data

  def teamwork
    Teamwork::Client.new teamwork_api_key
  end
end

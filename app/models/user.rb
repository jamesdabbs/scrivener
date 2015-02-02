class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:github]
end

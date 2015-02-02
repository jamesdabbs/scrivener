class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    data = request.env["omniauth.auth"]
    info = data["info"]

    user = User.where(gh_username: info["nickname"]).first_or_create! do |u|
      token  = data["credentials"]["token"]
      client = Octokit::Client.new access_token: token
      unless client.organizations.find { |o| o.login == "theironyard" }.present?
        redirect_to root_path,
          error: "You must be a member of The Iron Yard (Github team) to register"
        return
      end

      u.name     = info["name"]
      u.gh_token = token
      u.gh_data  = data
    end

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
  end
end

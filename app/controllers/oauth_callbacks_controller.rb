class OauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :check_email

  def github
    omniauth_callback('Github')
  end

  def facebook
    omniauth_callback('Facebook')
  end

  private

  def check_email
    unless OmniAuth::AuthHash.new(request.env['omniauth.auth']).info[:email]
      redirect_to new_user_registration_path, notice: 'Email was undefinded, but you can sign up your account'
    end
  end

  def omniauth_callback(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end

end

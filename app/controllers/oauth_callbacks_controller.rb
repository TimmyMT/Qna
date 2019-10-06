class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    omniauth_callback('Github')
  end

  def facebook
    omniauth_callback('Facebook')
  end

  private

  def omniauth_callback(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end

end

class ApplicationController < ActionController::Base
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization

  private

  def gon_user
    if signed_in?
      gon.current_user_id = current_user.id
    end
  end

end

class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    if signed_in?
      gon.current_user_id = current_user.id
      gon.user_signed_in = true
    else
      gon.user_signed_in = false
    end
  end

end

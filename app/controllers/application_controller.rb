class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    if signed_in?
      gon.current_user_id = current_user.id
    end
  end

end

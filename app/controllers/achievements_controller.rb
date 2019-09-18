class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @user_achievements = current_user.achievements
  end

end

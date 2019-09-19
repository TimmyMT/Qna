class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @achievements = current_user.achievements
  end

end

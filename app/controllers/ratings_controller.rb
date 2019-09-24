class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_rating

  def up
    @rating.up(current_user)

    respond_to { |format| format.json { render json: @rating } }
  end

  def down
    @rating.down(current_user)

    respond_to { |format| format.json { render json: @rating } }
  end

  def clear_vote_from
    @rating.clear_vote(current_user)

    respond_to { |format| format.json { render json: @rating } }
  end

  private

  def find_rating
    @rating = Rating.find(params[:id])
  end

end

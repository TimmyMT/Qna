class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_rating, only: [:up, :down, :clear_vote_from]

  def up
    @rating.up(current_user)

    render_rating_json
  end

  def down
    @rating.down(current_user)

    render_rating_json
  end

  def clear_vote_from
    @rating.clear_vote(current_user)

    render_rating_json
  end

  private

  def render_rating_json
    respond_to do |format|
      if @rating.save
        format.json { render json: @rating }
      end
    end
  end

  def find_rating
    @rating = Rating.find(params[:id])
  end

end

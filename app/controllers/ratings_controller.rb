class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_rating, only: [:up, :down, :clear_vote_from]

  def up
    @rating.up(current_user)

    respond_to do |format|
      if @rating.save
        format.json { render json: @rating }
      end
    end

    # @rating.save
    # redirect_after_action
  end

  def down
    @rating.down(current_user)

    respond_to do |format|
      if @rating.save
        format.json { render json: @rating }
      end
    end

    # @rating.save
    # redirect_after_action
  end

  def clear_vote_from
    @rating.clear_vote(current_user)

    respond_to do |format|
      if @rating.save
        format.json { render json: @rating }
      end
    end

    # @rating.save
    # redirect_after_action
  end

  private

  def find_rating
    @rating = Rating.find(params[:id])
  end

  def redirect_after_action
    @klass = @rating.ratingable_type.constantize

    if @klass == Answer
      @question = @klass.find(@rating.ratingable_id).question
    else
      @question = @klass.find(@rating.ratingable_id)
    end

    redirect_to question_path(@question)
  end

end

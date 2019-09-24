class VotesController < ApplicationController

  def create
    return redirect_to request.referrer, alert: 'You cant changes votes for your created object' if current_user&.creator?(votable)

    unless votable.votes.find_by(user: current_user).present?
      @vote = votable.votes.build value: params[:value], user: current_user
      @vote.save!
      redirect_to @vote.votable, notice: 'Your vote given'
    else
      redirect_to request.referrer, alert: 'Your vote already have'
    end
  end

  def destroy
    if Vote.find_by(user: current_user, votable_id: params[:votable_id]).present?
      @vote = Vote.find_by(votable_id: params[:votable_id], user: current_user)
      @vote.destroy
      redirect_to @vote.votable, notice: 'Your vote pick up'
    else
      redirect_to request.referrer, alert: 'Failure'
    end
  end

  private

  def votable
    klass = params[:class_name].safe_constantize
    klass.find(params[:class_name_id])
  end

end

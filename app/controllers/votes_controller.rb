class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    return if current_user&.creator?(votable)

    unless votable.votes.find_by(user: current_user).present?
      @votable_klass = votable.class.to_s.downcase
      @vote = votable.votes.build value: params[:value], user: current_user
      @vote.save!

      render json: [votable, votable.votes.sum(:value), @votable_klass]
    else
      render json: [votable, votable.votes.sum(:value)]
    end
  end

  def destroy
    return if current_user&.creator?(object)

    if Vote.find_by(user: current_user, votable_id: params[:votable_id]).present?
      @vote = Vote.find_by(votable_id: params[:votable_id], user: current_user)
      @object = @vote.votable_type.safe_constantize.find(@vote.votable_id)
      @object_klass = @object.class.to_s.downcase
      @vote.destroy!

      render json: [@object, @object.votes.sum(:value), @object_klass]
    else
      render json: [object, object.votes.sum(:value)]
    end
  end

  private

  def object
    @vote = Vote.find_by(votable_id: params[:votable_id])
    @object = @vote.votable_type.safe_constantize.find(params[:votable_id])
  end

  def votable
    klass = params[:class_name].safe_constantize
    klass.find(params[:class_name_id])
  end

end

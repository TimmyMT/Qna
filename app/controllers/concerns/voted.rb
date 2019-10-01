module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: [:vote_up, :vote_down, :vote_clear]
    before_action :vote_access, only: [:vote_up, :vote_down]
  end

  def vote_up
    @resource.vote_up(current_user)
    render_json
  end

  def vote_down
    @resource.vote_down(current_user)
    render_json
  end

  def vote_clear
    if @resource.voted?(current_user)
      @resource.vote_clear(current_user)
      render_json
    else
      head :unprocessable_entity
    end
  end

  private

  def vote_access
    return head :unprocessable_entity unless signed_in?

    if @resource.voted?(current_user) || current_user.creator?(@resource)
      head :unprocessable_entity
    end
  end

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json
    render json: { rating: @resource.rating, klass: @resource.class.to_s, id: @resource.id }
  end
end

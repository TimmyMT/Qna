class Api::V1::ProfilesController < Api::V1::BaseController

  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end

  def me
    render json: current_resource_owner
  end

end

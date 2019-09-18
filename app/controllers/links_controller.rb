class LinksController < ApplicationController

  def destroy
    @link = Link.find(params[:id])

    @link.destroy if current_user&.creator?(@link.linkable)
  end

end

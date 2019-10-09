class AttachmentsController < ApplicationController

  authorize_resource

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    @file.purge
  end

end

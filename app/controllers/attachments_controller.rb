class AttachmentsController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    @file.purge if current_user&.creator?(@file.record)
  end

end

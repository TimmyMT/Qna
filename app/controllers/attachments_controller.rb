class AttachmentsController < ApplicationController

  def delete_attachment
    @file = ActiveStorage::Attachment.find(params[:id])

    @file.purge
    redirect_to question_path(@file.record_id)
  end

end

class AttachmentsController < ApplicationController

  def delete_attachment
    file = ActiveStorage::Attachment.find(params[:id])
    class_name = file.record_type.constantize

    if current_user&.creator?(class_name.find(file.record_id))
      file.purge

      redirect_to request.referer, notice: 'File successfully deleted'
    else
      redirect_to request.referer, alert: 'File not deleted'
    end
  end

end

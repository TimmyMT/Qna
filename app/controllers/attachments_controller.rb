class AttachmentsController < ApplicationController

  def delete_attachment
    @file = ActiveStorage::Attachment.find(params[:id])
    class_name = @file.record_type.constantize

    @file.purge if current_user&.creator?(class_name.find(@file.record_id))
  end

end

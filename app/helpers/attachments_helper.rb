module AttachmentsHelper
  def record_creator?(file)
    class_name = file.record_type.constantize
    return current_user&.creator?(class_name.find(file.record_id))
  end

  def files_present?(object)
    object.files.attached?
  end
end

module AttachmentsHelper
  def record_creator?(file)
    parent_klass = file.record_type.safe_constantize
    parent = parent_klass.find(file.record_id)
    return current_user&.creator?(parent)
  end

  def files_present?(object)
    object.files.attached?
  end
end

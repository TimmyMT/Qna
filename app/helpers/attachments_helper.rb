module AttachmentsHelper
  def record_creator?(file)
    current_user&.creator?(file.record)
  end

  def files_present?(object)
    object.files.attached?
  end
end

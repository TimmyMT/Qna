module ApplicationHelper

  def have_permission?(object)
    if current_user.present?
      object.user == current_user
    else
      false
    end
  end

end

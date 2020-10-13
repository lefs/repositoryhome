module ApplicationHelper
  def admins_only(&block)
    block.call if current_user.try(:admin?)
    nil
  end

  def find_user_email(id)
    User.find(id).email
  end

  def find_repository_name(id)
    Repository.find(id).name
  end
end

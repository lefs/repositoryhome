class UserObserver < ActiveRecord::Observer
  def before_create(user)
    user.reset_password_token = User.reset_password_token
    # Needed or Devise assumes assumes token has expired.
    user.reset_password_sent_at = Time.now
  end

  def after_create(user)
    UserMailer.new_user_email(user).deliver
  end
end

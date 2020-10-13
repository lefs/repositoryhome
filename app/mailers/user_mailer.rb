class UserMailer < ActionMailer::Base
  default from: 'repositoryhome@localhost'

  def new_user_email(user)
    @user = user
    @token = @user.reset_password_token
    subject = 'Your Repository Home account is ready'
    mail(to: user.email, subject: subject)
  end
end

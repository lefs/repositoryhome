require 'spec_helper'

describe UserMailer do
  describe '.new_user_email' do
    before(:each) do
      ActiveRecord::Observer.with_observers(:user_observer) do
        @user = FactoryGirl.create(:user)
      end
      @email = UserMailer.new_user_email(@user)
    end

    it 'delivers an email to the User passed in' do
      @email.should deliver_to(@user.email)
    end

    it 'provides a link for the user to create a password' do
      token = @user.reset_password_token
      token.should_not be_blank
      @email.should have_body_text(/#{token}/)
    end
  end
end

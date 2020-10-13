require 'spec_helper'

describe UserObserver do
  describe '#before_create' do
    it 'sets a reset_password_token to be used in setting a new password' do
      ActiveRecord::Observer.with_observers(:user_observer) do
        user = FactoryGirl.create(:user)
        user.reset_password_token?.should be_true
      end
    end
  end

  describe '#after_create' do
    it 'sends email with login instructions to the newly created user' do
      ActiveRecord::Observer.with_observers(:user_observer) do
        UserMailer.should_receive(:new_user_email).and_return(double('mailer', deliver: true))
        FactoryGirl.create(:user)
      end
    end
  end
end

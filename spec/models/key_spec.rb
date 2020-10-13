require 'spec_helper'

describe Key do
  let(:user) { FactoryGirl.create(:user) }

  it 'can be created with a name, body, and user_id' do
    key = Key.new
    key.user_id = user.id
    key.name = 'key name'
    key.body = 'ssh-rsa pBuIAV5arvCmflD/D0u5qn8Z2cb6o7cQXQ== simple_user'
    key.save.should be_true
  end

  it "can't be created without a name or body" do
    key = Key.new
    key.valid?.should be_false
    key.errors[:name].any?.should be_true
    key.errors[:body].any?.should be_true
    key.errors[:name].should == ["can't be blank"]
    key.errors[:body].should == ["can't be blank"]
    key.save.should be_false
  end

  it "can't have a name over 512 characters" do
    key = Key.new
    key.name = 'i' * 520
    key.save.should be_false
    key.errors[:name].should == ['is too long (maximum is 512 characters)']
  end
end

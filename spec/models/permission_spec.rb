require 'spec_helper'

describe Permission do
  let(:repo) { FactoryGirl.create(:repository) }
  let(:user) { FactoryGirl.create(:user) }

  it 'can not be saved without user_id, repository_id and name' do
    perm = Permission.new
    perm.valid?.should be_false
    perm.errors[:user].any?.should be_true
    perm.errors[:repository].any?.should be_true
    perm.errors[:name].any?.should be_true
    perm.save.should be_false
  end

  it 'has a name attribute which is a single character' do
    perm = Permission.new
    perm.user_id = user.id
    perm.repository_id = repo.id
    perm.name = 'rr'
    perm.save.should be_false
    errors = ['is the wrong length (should be 1 characters)', 'is invalid']
    perm.errors[:name].should == errors
  end

  it "only accepts 'r', 'w', 'f' as name" do
    perm = Permission.new
    perm.user_id = user.id
    perm.repository_id = repo.id
    ['f', 'w', 'r'].each do |name|
      perm.name = name
      perm.valid?.should be_true
    end
    perm.name = 'y'
    perm.save.should be_false
    perm.errors[:name].should == ['is invalid']
  end
end

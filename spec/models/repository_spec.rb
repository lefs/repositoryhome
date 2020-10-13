require 'spec_helper'

describe Repository do
  it 'can not be saved without a name' do
    repo = Repository.new
    repo.valid?.should be_false
    repo.errors[:name].any?.should be_true
    repo.errors[:name].should == ["can't be blank", 'is invalid']
    repo.save.should be_false
  end

  it 'deletes associated permissions when deleted' do
    repo = FactoryGirl.create(:repository)
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:permission, user_id: user, repository_id: repo)

    # Confirm that the repository has permissions associated with it.
    Permission.find_by_repository_id(repo.id).should_not be_nil

    # Delete the repository.
    repo_id = repo.id
    repo.destroy
    lambda { Repository.find(repo) }.should raise_error(ActiveRecord::RecordNotFound)
    # Confirm that the repository's permissions have also been deleted.
    Permission.find_by_repository_id(repo_id).should be_nil
  end

  it 'returns a repository for git access' do
    user = FactoryGirl.create(:user)
    name = FactoryGirl.create(:repository).name_on_disk
    key_id = FactoryGirl.create(:key, user_id: user).id
    lambda {
      Repository.find_by_name_key_id_and_access_type(name, key_id, :read)
    }.should_not raise_error
  end

  it "saves associated permissions that have a name set and discards those that don't" do
    repo = Repository.new(name: 'test_proj')
    user_1 = FactoryGirl.create(:user, email: 'user_1@test.org')
    user_2 = FactoryGirl.create(:user, email: 'user_2@test.org')
    empty_permission = { name: '', user_id: user_1.id }
    full_permission = { name: 'f', user_id: user_2.id }
    repo.permissions.build(empty_permission)
    repo.permissions.build(full_permission)
    repo.save.should be_true
    repo.permissions.exists?.should be_true
    repo.permissions.length.should == 1
  end
end

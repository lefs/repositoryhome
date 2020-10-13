require 'spec_helper'

describe User do
  it 'deletes associated permissions and keys when it gets deleted' do
    repo = FactoryGirl.create(:repository)
    user = FactoryGirl.create(:user)
    user_key = FactoryGirl.create(:key, user_id: user.id)
    perm = FactoryGirl.create(:permission,
                              user_id: user.id,
                              repository_id: repo.id)

    # Confirm that user does indeed have the key and repository permission.
    lambda { user.keys.find(user_key) }.should_not raise_error
    lambda { user.permissions.find(perm) }.should_not raise_error

    # Delete the user.
    uid = user.id
    user.destroy
    lambda { User.find(@user) }.should raise_error(ActiveRecord::RecordNotFound)

    # The user's permissions and keys should have also been deleted.
    Key.find_by_user_id(uid).should be_nil
    Permission.find_by_user_id(uid).should be_nil
  end
end

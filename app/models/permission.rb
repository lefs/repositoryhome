class Permission < ActiveRecord::Base
  belongs_to :user, inverse_of: :permissions
  belongs_to :repository, inverse_of: :permissions

  attr_accessible :user_id, :repository_id, :name

  validates :user, presence: true
  validates :repository, presence: true
  ############################################################################
  # A permission can only be one of the following:                           #
  # 'r' meaning the user can only read the repository                        #
  # 'w' meaning the user can just read/write the repository                  #
  # 'f' meaning the user has full rights on the repository (delete/rename)   #
  ############################################################################
  validates :name, presence: true,
                   length: { is: 1 },
                   format: { with: /^[rwf]$/i }
end

class Repository < ActiveRecord::Base
  MAX_NAME_LENGTH = 64
  MAX_DESCRIPTION_LENGTH = 190

  has_many :permissions, dependent: :delete_all,
                         inverse_of: :repository,
                         uniq: true,
                         autosave: true
  has_many :users, through: :permissions
  accepts_nested_attributes_for :permissions
  attr_accessible :name, :description, :permissions_attributes

  validates :name, presence: true,
                   uniqueness: true,
                   format: { with: /^[A-Za-z\d_-]+$/ },
                   length: { maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }

  scope :with_permission, select('repositories.*, permissions.name as permission')

  before_validation :mark_permissions_for_destruction

  def self.search(query)
    query ? where("repositories.name LIKE ?", "%#{query}%") : scoped
  end

  # The repository name on disk - url friendly and with .git extension.
  def name_on_disk
    "#{name}.git"
  end

  # Uses the git name to generate the full repository path.
  def path
    "#{Repositoryhome.config.repositories_dir}/#{name_on_disk}"
  end

  # Checks whether the repository name given is in use.
  def self.name_taken?(name)
    !find_by_name name
  end

  # From the supplied key id and repository name compute whether the desired
  # access type is allowed for the user.
  #
  # Possible access types - :read and :write.
  def self.find_by_name_key_id_and_access_type(repo_name, key_id, access_type)
    unless [:read, :write].include? access_type
      raise ArgumentError, 'access_type must be :read or :write'
    end

    repo = Repository.find_by_name(repo_name.split('.git').first)
    key = Key.find_by_id(key_id)
    return nil unless repo && key

    user = key.user
    return repo if user.admin?

    permission =
      Permission.where(user_id: user.id, repository_id: repo.id).first
    return nil unless permission

    'rwa'.include?(permission.name) ? repo : nil
  end

  protected

  def mark_permissions_for_destruction
    permissions.each do |permission|
      permission.mark_for_destruction if permission.name.blank?
    end
  end
end

class RepositoryObserver < ActiveRecord::Observer
  include RepositoryFileutils

  def before_create(repository)
    begin
      if GitManager.create(repository.path) == false
        repository.errors[:base] << 'Repository already exists on disk.'
        return false
      end
    rescue
      repository.errors[:base] << 'Repository could not be created on disk.'
      return false
    end
  end

  def before_destroy(repository)
    begin
      GitManager.destroy! repository.path
    rescue
      return false
    end
  end
end

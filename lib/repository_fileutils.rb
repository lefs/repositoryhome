require 'fileutils'

module RepositoryFileutils
  module GitManager
    # Create a new repository.
    def self.create(path)
      FileUtils.mkdir_p path, mode: 0750  # Less permissive than Git.new.
      Dir.chdir(path) do
        repo = Grit::Git.new path
        repo.init []  # Returns false if the repository already exists.
      end
    end

    # Delete a repository.
    def self.destroy!(path)
      FileUtils.rm_rf path
    end
  end

  def exists_on_disk?(path)
    File.directory? path
  end
end

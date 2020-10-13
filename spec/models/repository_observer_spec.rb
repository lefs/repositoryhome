require 'spec_helper'
require 'fakefs/safe'

describe RepositoryObserver do
  include RepositoryFileutils

  let(:repo) { Repository.new(name: 'repo') }

  describe '#before_create' do
    it 'creates repository on disk' do
      FakeFS.activate!
      ActiveRecord::Observer.with_observers(:repository_observer) do
        repo.save.should be_true
      end
      exists_on_disk?(repo.path).should be_true
      FakeFS.deactivate!
    end
  end

  describe '#before_destroy' do
    it 'deletes repository from disk' do
      FakeFS.activate!
      ActiveRecord::Observer.with_observers(:repository_observer) { repo.save }
      exists_on_disk?(repo.path).should be_true  # Confirm it's there.
      ActiveRecord::Observer.with_observers(:repository_observer) { repo.destroy }
      exists_on_disk?(repo.path).should be_false
      FakeFS.deactivate!
    end
  end
end

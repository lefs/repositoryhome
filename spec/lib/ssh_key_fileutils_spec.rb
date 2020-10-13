require 'spec_helper'
require 'fakefs/safe'
require 'fileutils'
require 'tempfile'

# Note: Not using FakeFS in all the tests because SSHKeyFileutils uses Tempfile
# and FakeFS 0.4.0 has a bug: https://github.com/defunkt/fakefs/issues/17.

describe SSHKeyFileutils do
  include SSHKeyFileutils

  let(:key) { { id: 3, body: 'ssh-rsa pBuIAV5arvCmflD/D02cb6o7cQXQ==' } }

  describe '#append_key' do
    it 'appends an SSH key to a file' do
      FakeFS do
        FileUtils.touch('authorized_keys')
        append_key(key, 'authorized_keys')
        key_in_file?(key, 'authorized_keys').should be_true
      end
    end
  end

  describe '#delete_key' do
    it 'deletes an SSH key from a file' do
      authorized_keys = Tempfile.new('authorized_keys')
      authorized_keys << prepare_key_for_file(key)
      authorized_keys.rewind
      delete_key(key, authorized_keys.path)
      key_in_file?(key, authorized_keys.path).should be_false
      authorized_keys.close
    end
  end

  describe '#update_key' do
    it 'updates an SSH key in a file' do
      authorized_keys = Tempfile.new('authorized_keys')
      authorized_keys << prepare_key_for_file(key)
      authorized_keys.rewind
      new_key = { id: 4, body: 'ssh-rsa asdIAVXHYUCm6o7c123==' }

      update_key(key, new_key, authorized_keys.path)
      key_in_file?(new_key, authorized_keys.path).should be_true
      key_in_file?(key, authorized_keys.path).should be_false
      authorized_keys.close
    end
  end
end

require 'tempfile'
require 'fileutils'

# Utilities to write/delete/update ssh keys (as they come from the database)
# into an authorized_keys file.
module SSHKeyFileutils
  # Takes a hash that contains a key id and a key body and adds comments,
  # command, and flags so that it can be saved in an authorized_keys file.
  # { id: => 'key name', :body => 'ssh-rsa uIAV5arvCmZ2cb6o7c...'}.
  def prepare_key_for_file(key)
    unless key.kind_of?(Hash) && key.keys == [:id, :body]
      raise ArgumentError, 'key must be a Hash with an :id and :body keys'
    end

    cmd = File.expand_path('script/repositoryhome', Rails.configuration.root)
    %Q{command="#{cmd} #{key[:id]}",no-port-forwarding,} +
    %Q{no-X11-forwarding,no-agent-forwarding,no-pty #{key[:body]}\n}
  end

  def append_key(key, filepath)
    keys_to_file nil, key, filepath
  end

  def delete_key(key, filepath)
    keys_to_file key, nil, filepath
  end

  def update_key(old_key, new_key, filepath)
    keys_to_file old_key, new_key, filepath
  end

  # The workhorse method. It takes up to two hashes that contain a key id
  # and a key body each plus the path of an authorized_keys file. Depending
  # on what arguments you pass it does one of the following things:
  #
  # (a) If you pass both keys it replaces old_key with new_key.
  # (b) If the old_key is nil then it appends new_key in the file.
  # (c) If you pass nil as the new_key it simply deletes the old_key.
  def keys_to_file(old_key, new_key, filepath)
    old_key = prepare_key_for_file(old_key) if old_key
    new_key = new_key ? prepare_key_for_file(new_key) : ''

    if old_key
      # Delete or update key if we're here.
      mode = 'r'
      write_to_file = lambda do |f|
        temp = Tempfile.new('working')
        while (line = f.gets)
          line.gsub!(old_key, new_key) if line.match(old_key)
          temp << line unless line == ''
        end
        temp.close
        FileUtils.cp(filepath, "#{filepath}.bak")
        FileUtils.mv(temp.path, filepath)
      end
    else
      # Append a key if we are here.
      mode = 'a'
      write_to_file = lambda { |f| f << new_key }
    end

    File.open(filepath, mode) do |f|
      f.flock File::LOCK_EX unless Rails.env.test?
      write_to_file.call(f)
      f.flock File::LOCK_UN unless Rails.env.test?
    end
  end

  # Takes a key hash and a path to an authorized_keys file and examines
  # if the key is in the file.
  def key_in_file?(key, filepath)
    false unless File.exists?(filepath)
    File.open(filepath, 'r') do |f|
      !! f.read.match(prepare_key_for_file(key))
    end
  end
end

class KeyObserver < ActiveRecord::Observer
  include SSHKeyFileutils

  # Add the user's key to the authorized_keys file.
  def after_create(key)
    k = { id: key.id, body: key.body }
    begin
      append_key k, Repositoryhome.config.authorized_keys_file
    rescue
      raise ActiveRecord::Rollback, 'Error writing SSH key to the filesystem'
    end
  end

  # Update an existing key if the key content has changed.
  def before_update(key)
    return unless key.body_changed?

    old_key = { id: key.id, body: key.body_was }
    new_key = { id: key.id, body: key.body }
    begin
      update_key old_key, new_key, Repositoryhome.config.authorized_keys_file
    rescue
      return false
    end
  end

  # User deleted the key, delete it from the authorized_keys file too.
  def before_destroy(key)
    k = { id: key.id, body: key.body }
    begin
      delete_key k, Repositoryhome.config.authorized_keys_file
    rescue
      return false
    end
  end
end

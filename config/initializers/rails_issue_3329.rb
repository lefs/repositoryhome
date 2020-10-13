# Fixes "Autosave association doesn't save all records on a new record for a
# collection association if there are records marked for destruction".
# See https://github.com/rails/rails/pull/3329 and
# https://github.com/rails/rails/commit/d802a6c275fa79d25173cda1c06764e6b0e87902
# PS. This code is ugly.

# if Rails.version == "3.2.3"
if Rails.version.start_with?('3.2')
  module ActiveRecord
    module AutosaveAssociation
      private

      # Saves any new associated records, or all loaded autosave associations
      #  if <tt>:autosave</tt> is enabled on the association.
      #
      # In addition, it destroys all children that were marked for destruction
      # with mark_for_destruction.
      #
      # This all happens inside a transaction, _if_ the Transactions module is
      # included into ActiveRecord::Base after the AutosaveAssociation module,
      # which it does by default.
      def save_collection_association(reflection)
        if (association = association_instance_get(reflection.name))
          autosave = reflection.options[:autosave]

          if (records =
                associated_records_to_validate_or_save(association,
                                                       @new_record_before_save,
                                                       autosave))
            begin
              records_to_destroy = []
              records.each do |record|
                next if record.destroyed?

                saved = true

                if autosave && record.marked_for_destruction?
                  records_to_destroy << record
                elsif autosave != false && (@new_record_before_save || record.new_record?)
                  if autosave
                    saved = association.insert_record(record, false)
                  else
                    association.insert_record(record) unless reflection.nested?
                  end
                elsif autosave
                  saved = record.save(validate: false)
                end

                raise ActiveRecord::Rollback unless saved
              end

              records_to_destroy.each do |record|
                association.proxy.destroy(record)
              end
            rescue
              records.each { |x| IdentityMap.remove(x) } if IdentityMap.enabled?
              raise
            end
          end
          # reconstruct the scope now that we know the owner's id
          association.send(:reset_scope) if association.respond_to?(:reset_scope)
        end
      end
    end
  end
end

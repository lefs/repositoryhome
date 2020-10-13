class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name,           null: false
      t.references :repository, null: false
      t.references :user,       null: false

      t.timestamps
    end
    add_index :permissions, :repository_id
    add_index :permissions, :user_id
    add_index :permissions, [:user_id, :repository_id],
              unique: true,
              name: 'by_user_and_repository'
  end
end

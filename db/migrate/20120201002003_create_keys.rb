class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :name,     null: false
      t.text :body,       null: false
      t.references :user, null: false

      t.timestamps
    end
    add_index :keys, :user_id
  end
end

class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :repositories, :name, unique: true
  end
end

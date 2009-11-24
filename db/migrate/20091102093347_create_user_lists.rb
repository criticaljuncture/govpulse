class CreateUserLists < ActiveRecord::Migration
  def self.up
    create_table :user_lists do |t|
      t.belongs_to :user
      t.string :name, :slug
      t.boolean :public, :default => false
      t.timestamps
    end
    add_index :user_lists, :user_id
  end

  def self.down
    drop_table :user_lists
  end
end

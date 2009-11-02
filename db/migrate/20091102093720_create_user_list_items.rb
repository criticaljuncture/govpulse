class CreateUserListItems < ActiveRecord::Migration
  def self.up
    create_table :user_list_items do |t|
      t.belongs_to :entry
      t.belongs_to :user_list
      t.timestamps
    end
    add_index :user_list_items, :entry_id
    add_index :user_list_items, :user_list_id
  end

  def self.down
    drop_table :user_list_items
  end
end

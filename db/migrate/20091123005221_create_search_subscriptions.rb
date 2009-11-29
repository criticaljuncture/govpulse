class CreateSearchSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :search_subscriptions do |t|
      t.belongs_to :user
      t.string :title, :frequency
      t.string :search_params, :length => 4094
      t.timestamps
    end
    
    add_index :search_subscriptions, :user_id
  end

  def self.down
    drop_table :search_subscriptions
  end
end

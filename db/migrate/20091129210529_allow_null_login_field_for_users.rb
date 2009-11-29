class AllowNullLoginFieldForUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :login, :string, :null => true, :default => nil
  end

  def self.down
  end
end

class UserListItem < ActiveRecord::Base
  belongs_to :user_list_item
  belongs_to :entry
  
  validates_uniqueness_of :entry, :scope  => :user_list_id
end

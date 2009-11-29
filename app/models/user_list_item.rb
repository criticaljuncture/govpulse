=begin Schema Information

 Table name: user_list_items

  id           :integer(4)      not null, primary key
  entry_id     :integer(4)
  user_list_id :integer(4)
  created_at   :datetime
  updated_at   :datetime

=end Schema Information

class UserListItem < ActiveRecord::Base
  belongs_to :user_list_item
  belongs_to :entry
  
  validates_uniqueness_of :entry, :scope  => :user_list_id
end

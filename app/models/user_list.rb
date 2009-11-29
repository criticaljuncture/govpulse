=begin Schema Information

 Table name: user_lists

  id         :integer(4)      not null, primary key
  user_id    :integer(4)
  name       :string(255)
  slug       :string(255)
  public     :boolean(1)
  created_at :datetime
  updated_at :datetime

=end Schema Information

class UserList < ActiveRecord::Base
  belongs_to :user
  
  has_many :user_list_items, :dependent => :destroy
  
  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :user_id
  validates_length_of     :name, :maximum => 200 #leave room to create slug
  
  before_validation :update_or_create_slug
  
  def to_param
    slug_changed? ? slug_was : slug
  end


  
  private
  
  def update_or_create_slug
    if self.new_record? || self.name_changed? || self.slug.blank?
      self.slug = self.name.try(:slugize)
    end
  end
end

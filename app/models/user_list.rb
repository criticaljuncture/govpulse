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

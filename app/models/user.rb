=begin Schema Information

 Table name: users

  id                  :integer(4)      not null, primary key
  login               :string(255)     not null
  email               :string(255)     not null
  crypted_password    :string(255)     not null
  password_salt       :string(255)     not null
  persistence_token   :string(255)     not null
  single_access_token :string(255)     not null
  perishable_token    :string(255)     not null
  login_count         :integer(4)      default(0), not null
  failed_login_count  :integer(4)      default(0), not null
  last_request_at     :datetime
  current_login_at    :datetime
  last_login_at       :datetime
  current_login_ip    :string(255)
  last_login_ip       :string(255)
  created_at          :datetime
  updated_at          :datetime

=end Schema Information

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.logged_in_timeout                       = 2.hours 
    c.crypto_provider                         = Authlogic::CryptoProviders::BCrypt
    c.validate_password_field                 = false
    c.require_password_confirmation           = false
  end

  has_many :user_lists, :dependent => :destroy
  
  validates_presence_of   :login
  validates_presence_of   :email, :if => Proc.new{|u| u.new_record?}
  validates_uniqueness_of :login, :email
  
  validates_length_of :password, :minimum => 6
  
  before_validation :create_slug
  
  def to_param
    login
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    PasswordResetNotifier.deliver_password_reset_instructions(self)  
  end


  
  private
  
  def create_slug
    if self.new_record? || self.login.blank?
      self.login = self.login.try(:slugize)
    end
  end
end

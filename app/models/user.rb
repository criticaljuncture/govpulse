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

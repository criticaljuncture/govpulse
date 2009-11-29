class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.crypto_provider                         = Authlogic::CryptoProviders::BCrypt
    c.login_field                             = :email
    c.validate_login_field                    = false
    c.validate_password_field                 = false
    c.require_password_confirmation           = false
  end
  
  attr_accessor :has_account
  
  has_many :user_lists, :dependent => :destroy
  
  validates_presence_of   :email
  validates_uniqueness_of :login, :allow_nil => true 
  validates_uniqueness_of :email
  
  validates_length_of :password, :minimum => 6
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    PasswordResetNotifier.deliver_password_reset_instructions(self)
  end

  def sign_in_type
    'register'
  end
  
end

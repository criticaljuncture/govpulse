class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email
    c.logged_in_timeout = 2.hours 
    c.crypto_provider   = Authlogic::CryptoProviders::BCrypt
  end
  
  validates_uniqueness_of :login, :email
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    PasswordResetNotifier.deliver_password_reset_instructions(self)  
  end
end

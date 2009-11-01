class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.logout_on_timeout = 2.hours 
    c.crypto_provider   = Authlogic::CryptoProviders::BCrypt
  end
  
  validates_length_of :password, :minimum => 6
  validates_format_of :password, :with => /[a-z]/i :message => "must include a letter"
  validates_format_of :password, :with => /[0-9]/  :message => "must include a number"
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    PasswordResetNotifier.deliver_password_reset_instructions(self)  
  end
end

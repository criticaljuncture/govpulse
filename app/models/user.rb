class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email
    c.logged_in_timeout = 2.hours 
    c.crypto_provider   = Authlogic::CryptoProviders::BCrypt
  end

  has_many :user_lists, :dependent => :destroy
  
  validates_presence_of   :login, :email
  validates_uniqueness_of :login, :email
  
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

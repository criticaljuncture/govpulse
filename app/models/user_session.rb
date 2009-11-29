class UserSession < Authlogic::Session::Base
  attr_accessor :email
  def sign_in_type
    'login'
  end
end
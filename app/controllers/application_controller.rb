# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include RouteBuilder
  
  # Authorization methods
  include AuthenticationUtils
  include AuthorizationUtils
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include Locator
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end

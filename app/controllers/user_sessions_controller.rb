class UserSessionsController < ApplicationController
  before_filter :require_not_logged_in, :only => [:new, :create]
  before_filter :require_login, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user])
    if @user_session.save
      flash[:notice] = "Login successful!"
      respond_to do |wants|
        wants.html {}
        wants.js {render :action => :login_success}
      end
    else
      respond_to do |wants|
        wants.html {}
        wants.js {render :action => :new}
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
end
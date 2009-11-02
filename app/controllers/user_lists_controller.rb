class UserListsController < ApplicationController
  before_filter :require_login
  
  resource_controller
  actions :all, :except => :index
  belongs_to :user
  
  new_action.before do
    @object = UserList.new
  end
  
  private
    
  def object
    @object ||= UserList.find(:first, 
                              :include => {:user_list_items => :entry},
                              :conditions => ['user_lists.slug = ? && user_lists.user_id = ?',
                                              params[:id], parent_object]
                              )
  end
  
  
  
  protected
  
  def parent_object
    @parent_object ||= User.find_by_login(params[:user_id])
  end
end

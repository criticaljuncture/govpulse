=begin Schema Information

 Table name: search_subscriptions

  id            :integer(4)      not null, primary key
  user_id       :integer(4)
  title         :string(255)
  frequency     :string(255)
  search_params :string(255)
  created_at    :datetime
  updated_at    :datetime

=end Schema Information

class SearchSubscription < ActiveRecord::Base
  belongs_to :user
  
  def search_params
    ActiveSupport::JSON.decode(self.search_params)
  end
  
  def search_params=(params)
    self.search_params(params).to_json
  end
end

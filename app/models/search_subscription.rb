class SearchSubscription < ActiveRecord::Base
  belongs_to :user
  
  def search_params
    ActiveSupport::JSON.decode(self.search_params)
  end
  
  def search_params=(params)
    self.search_params(params).to_json
  end
end

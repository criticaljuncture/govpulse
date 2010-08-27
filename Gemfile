# you need to run bundle lock after editing

source :gemcutter
source 'http://gems.github.com'

# Specify gems that this application depends on 
gem 'rails',                 '2.3.5',    :require => nil
gem 'rack',                  '1.0.1'     
gem 'mysql',                 '2.7'

gem "nokogiri",              '1.3.2'
gem "chronic",               '0.2.3'
gem "zilkey-active_api",     '0.2.0',  :require => 'active_api'
gem "curb",                  '0.4.4.0'
gem "haml",                  '2.2.14'
gem "chriseppstein-compass", '0.8.8',  :require => 'compass'
gem "geokit",                '1.4.1',  :require => 'geokit'
gem 'mislav-will_paginate',  '2.3.11', :require => 'will_paginate'
gem "fastercsv",             '1.4.0'
gem "amatch",                '0.2.3'
gem "rubyzip",               '0.9.1',  :require => 'zip/zip'
gem "patron",                '0.4.2'

# sunlight gem and dependencies
gem "json"
gem "ym4r",     '0.6.1'
gem 'sunlight', '1.0.7'

gem 'thinking-sphinx',  '1.3.14', :require => 'thinking_sphinx'
gem 'hoptoad_notifier', '2.1.3'
gem "aws-s3",           '0.6.2', :require => "aws/s3"
gem 'paperclip',        '2.3.1.1'
gem 'stevedore',        '0.0.1'
gem 'region_extractor', '0.0.1'

# deployment recipes
gem 'thunder_punch',    '0.0.6', :require => false

# disabled as requires C library to install...
#the Locator module will return a fake result if not installed
# gem "geoip_city", '0.2.0'

group :development do
  gem 'mongrel'
  gem 'rails-footnotes'
end
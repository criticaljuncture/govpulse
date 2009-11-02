require 'iconv'
 
module ActiveSupport
  module Inflector
    extend self
  
    def slugize(words)
      slug = Iconv.iconv('ascii//TRANSLIT//IGNORE', 'utf-8', words).to_s
      slug.gsub!(/&/, 'and')
      slug.gsub!(/[^\w_-]+/i, '-')
      slug.gsub!(/\-{2,}/i, '-')
      slug.gsub!(/^\-|\-$/i, '')
      url_encode(slug.downcase)
    end
  
    def url_encode(word)
      URI.escape(word, /[^\w_+-]/i)
    end
  
  end
end
 
module ActiveSupport::CoreExtensions::String::Inflections
  def slugize
    ActiveSupport::Inflector.slugize(self)
  end
  
  def url_encode
    ActiveSupport::Inflector.url_encode(self)
  end
end
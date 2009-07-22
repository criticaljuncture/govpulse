require 'test_helper'

class TopicAssignmentTest < ActiveSupport::TestCase
  should_belong_to :entry
  should_belong_to :topic
  
  should_have_index :entry_id, :topic_id
end
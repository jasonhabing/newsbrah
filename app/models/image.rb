class Image < ActiveRecord::Base
  attr_accessible :big_story_id, :feed_item_id, :localcopy, :sourceurl
  belongs_to :big_story
  belongs_to :feed_item
end

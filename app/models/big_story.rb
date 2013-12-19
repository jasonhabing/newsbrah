class BigStory < ActiveRecord::Base
  attr_accessible :image, :title
  has_many :feed_items
  has_many :images
end

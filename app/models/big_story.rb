class BigStory < ActiveRecord::Base
  attr_accessible :image, :title, :published, :imageurl, :description
  has_many :feed_items
  has_many :images
end

class AddImageUrlToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :imageurl, :string
  end
end

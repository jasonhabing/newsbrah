class AddFeedSourceToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :feedsource, :string
  end
end

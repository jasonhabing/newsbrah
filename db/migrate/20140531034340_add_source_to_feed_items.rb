class AddSourceToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :source, :text
  end
end

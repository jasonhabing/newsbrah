class AddGuidToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :guid, :string
  end
end
